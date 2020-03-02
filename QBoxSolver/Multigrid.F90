! Multigrid
!
! Defines the type Grid that contains the data and subroutines to solve
! for the steady states of the Shrodinger equation on a given subgrid.

module Multigrid
    use Types, only: rp
    use Math
    implicit none
    private

    public :: Grid, gridConstructor
    
    type Grid
        private
        type(BraKet), public :: ket
        integer :: numberOfStates, resolution
        logical :: isPeriodicBoundary
        real(rp) :: dx, dtMax, mass
        real(rp), dimension(:, :), allocatable :: potential
        real(rp), dimension(:, :, :), allocatable :: states
    contains
        procedure :: initalize
        procedure, public :: findState
        procedure :: energyOperator
    end type Grid
contains
    function gridConstructor(numberOfStates, resolution, isPeriodicBoundary, length, mass, potential, states)
        implicit none
        integer, intent(IN) :: numberOfStates, resolution
        logical, intent(IN) :: isPeriodicBoundary
        real(rp), intent(IN) :: length, mass
        real(rp), dimension(:, :), intent(IN) :: potential
        real(rp), dimension(:, :, :), intent(IN) :: states
        type(grid) :: gridConstructor

        real(rp) :: dx

        ! the distance betwean grid points
        dx = length/(resolution - 1)

        call gridConstructor%initalize(numberOfStates, resolution, isPeriodicBoundary, dx, mass, potential, states)
    end function gridConstructor

    ! initalize an instance of the type Grid
    subroutine initalize(self, numberOfStates, resolution, isPeriodicBoundary, dx, mass, potential, states)
        implicit none
        integer, intent(IN) :: numberOfStates, resolution
        logical, intent(IN) :: isPeriodicBoundary
        real(rp), intent(IN) :: dx, mass
        real(rp), dimension(:, :), intent(IN) :: potential
        real(rp), dimension(:, :, :), intent(IN) :: states
        class(Grid) :: self

        self%numberOfStates = numberOfStates
        self%resolution = resolution
        self%isPeriodicBoundary = isPeriodicBoundary
        self%dx = dx
        self%mass = mass
        self%potential = potential
        self%states = states

        self%ket = braketConstructor(self%resolution, self%isPeriodicBoundary, self%dx)

        ! the maximum stable time step determined using Von Neumann stability analysis as a huristic
        self%dtMax = 2*self%mass*self%dx**2/(4 + self%mass*self%dx**2*maxval(self%potential))

        print *, "number of states:", numberOfStates, "resolution:", resolution, "is periodic boundary:", isPeriodicBoundary
        print *, "dx:", dx, "dt max:", self%dtMax, "mass:", mass
    end subroutine initalize

    subroutine findState(self, phi, targetEvolutionTime, targetIterations)
        implicit none
        real(rp), dimension(:, :), intent(INOUT) :: phi
        real(rp), intent(IN), optional :: targetEvolutionTime
        integer, intent(IN), optional :: targetIterations
        class(Grid) :: self

        real(rp) :: time, dt
        real(rp) :: inv2mass, mdx2, potentialMax
        real(rp), dimension(:, :), allocatable :: phi_dt
        integer :: i
        real(rp) :: N

        inv2mass = 1.0_rp/(2*self%mass)
        mdx2 = self%mass*self%dx**2
        potentialMax = maxval(self%potential)
        N = 0.0 ! TODO clean up normalization and such

        call self%ket%normalize(phi)

        ! start of algorithm for finding steady state solutions
        i = 1
        time = 0.0_rp
        do while(.true.)
            ! check if simulation termination conditions are satisfied the
            ! algorithm will terminate if the number of iterations exceed
            ! targetIterations or if the time simulated exceedes targetEvolutionTime
            if (present(targetEvolutionTime)) then
                if (time > targetEvolutionTime) then
                    exit
                end if
            else if (present(targetIterations)) then
                if (i > targetIterations) then
                    exit
                end if
            else
                print *, "WARNING: targetEvolutionTime and targetIterations are not set."
                exit
            end if

            ! ensure that the new solution satisfies the boundary conditions and
            ! that it forms an orthonormal set with the other steady state solutions
            call self%ket%boundaryCondition(phi)
            call self%ket%orthogonalize(phi, self%states, self%numberOfStates)

            ! calculate the finite difference aproximation of the time derivative of phi
            phi_dt = inv2mass*self%ket%laplacian(phi) - self%potential*phi

            ! the current time step determined using Von Neumann stability analysis as a huristic
            dt = self%dtMax - self%dtMax*mdx2*N/(4 + mdx2*(potentialMax + N))

            ! the new solution according to the forward Euler method
            phi = phi + dt*phi_dt

            ! N: a measure of the change in phi over time, which is an estemate of
            ! the states expected energy
            N = (1 - sqrt(self%ket%expectationValue(phi)))/dt

            time = time + dt
            i = i + 1
        end do
        ! end of algorithm for finding steady state solutions

        call self%ket%boundaryCondition(phi)
        call self%ket%orthogonalize(phi, self%states, self%numberOfStates)

        print *, "partial state found,", i, " iterations."
        call appendState(phi, self%states, self%numberOfStates, self%resolution)
    end subroutine findState

    function energyOperator(self, phi)
        real(rp), dimension(:, :), intent(IN) :: phi
        real(rp), dimension(:, :), allocatable :: energyOperator
        class(Grid) :: self

        energyOperator = -self%ket%laplacian(phi)/(2*self%mass) + self%potential*phi
    end function energyOperator

    ! ------------------- Other subroutines and functions -------------
    subroutine appendState(newState, states, numberOfStates, resolution)
        implicit none
        real(rp), dimension(:, :), intent(IN) :: newState
        real(rp), dimension(:, :, :), allocatable, intent(INOUT) :: states
        integer, intent(INOUT) :: numberOfStates
        integer, intent(IN) :: resolution

        real(rp), dimension(:, :, :), allocatable :: states_temp

        allocate(states_temp(numberOfStates + 1, resolution, resolution))
        states_temp(:numberOfStates, :, :) = states(:, :, :)
        states_temp(numberOfStates + 1, :, :) = newState(:, :)
        call move_alloc(states_temp, states)
        numberOfStates = numberOfStates + 1
    end subroutine appendState
end module Multigrid
