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
        real(rp) :: dx, dtMax, mass
        real(rp), dimension(:, :), allocatable :: potential
        real(rp), dimension(:, :, :), allocatable :: states
    contains
        procedure :: initalize
        procedure, public :: findState
        procedure :: energyOperator
    end type Grid
contains
    function gridConstructor(numberOfStates, resolution, length, mass, potential, states)
        implicit none
        integer, intent(IN) :: numberOfStates, resolution
        real(rp), intent(IN) :: length, mass
        real(rp), dimension(:, :), intent(IN) :: potential
        real(rp), dimension(:, :, :), intent(IN) :: states
        type(grid) :: gridConstructor

        real(rp) :: dx

        dx = length/(resolution - 1)

        call gridConstructor%initalize(numberOfStates, resolution, dx, mass, potential, states)
    end function gridConstructor

    subroutine initalize(self, numberOfStates, resolution, dx, mass, potential, states)
        implicit none
        integer, intent(IN) :: numberOfStates, resolution
        real(rp), intent(IN) :: dx, mass
        real(rp), dimension(:, :), intent(IN) :: potential
        real(rp), dimension(:, :, :), intent(IN) :: states
        class(Grid) :: self

        self%numberOfStates = numberOfStates
        self%resolution = resolution
        self%dx = dx
        self%mass = mass
        self%potential = potential
        self%states = states

        self%ket = braketConstructor(self%resolution, self%dx)
        self%dtMax = 2*self%mass*self%dx**2/(4 + self%mass*self%dx**2*maxval(self%potential))
        print *, numberOfStates, resolution,"dx", dx, "dt Max", self%dtMax, "mass", mass
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
        N = 0.0

        call self%ket%normalize(phi)
        
        i = 1
        time = 0.0_rp
        do while(.true.)
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
            call self%ket%boundryCondition(phi)
            call self%ket%orthogonalize(phi, self%states, self%numberOfStates)
            phi_dt = inv2mass*self%ket%laplacian(phi) - self%potential*phi

            dt = self%dtMax - self%dtMax*mdx2*N/(4 + mdx2*(potentialMax + N))

            phi = phi + dt*phi_dt
            N = (1 - sqrt(self%ket%expectationValue(phi)))/dt
            time = time + dt
            i = i + 1
        end do

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

    ! the dt tweaking mothod used in POC
    ! it attempts to limit the change in phi
    subroutine modify_dt_POC(phi, phi_dt, dt, r_max, r_min, swaps, swaps_max)
        implicit none
        real(rp), dimension(:, :), intent(IN) :: phi, phi_dt
        real(rp), intent(INOUT) :: dt
        real(rp), intent(INOUT) :: r_max, r_min
        integer, intent(INOUT) :: swaps
        integer, intent(IN) :: swaps_max

        real(rp) :: r

        r = dt*maxval(abs(phi_dt)) / maxval(abs(phi))
        if (r > r_max) then
            dt = dt*0.5_rp
            swaps = swaps + 1
        else if (r < r_min) then
            dt = dt*2.0_rp
            swaps = swaps + 1
        end if

        if (swaps > swaps_max) then
            swaps = 0
            r_max = r_max*0.5_rp
            r_min = r_min*0.5_rp
        end if
    end subroutine modify_dt_POC

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
