module Multigrid
    use Types, only: rp
    use Math
    implicit none
    private

    public :: Grid, gridConstructor
    
    type Grid
        private
        type(BraKet) :: ket
        integer :: numberOfStates, resolution
        real(rp) :: dx, dt, mass
        real(rp), dimension(:, :), allocatable :: potential
        real(rp), dimension(:, :, :), allocatable :: states
    contains
        procedure :: initalize
        procedure, public :: findState
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
        self%dt = self%mass*self%dx**2/2 ! TODO select dt using Von Neumann stability analysis

        print *, numberOfStates, resolution,"dx", dx, "mass", mass, rank(potential), rank(states)
    end subroutine initalize

    subroutine findState(self, phi)
        implicit none
        real(rp), dimension(:, :), intent(INOUT) :: phi
        class(Grid) :: self

        real(rp) :: inv2mass
        real(rp), dimension(:, :), allocatable :: phi_dt
        integer :: i

        real(rp) :: dt=0.1, r_max = 0.4_rp, r_min = 0.1_rp
        integer :: swaps = 0, swaps_max = 10

        inv2mass = 1.0_rp/(2*self%mass)
        call self%ket%normalize(phi)

        ! any change can propagate by one cell per step so total steps should be n*resolution where n > 1
        do i = 1, 50*1000
            call self%ket%boundryCondition(phi)
            call self%ket%orthogonalize(phi, self%states, self%numberOfStates)
            phi_dt = inv2mass*self%ket%laplacian(phi) - self%potential*phi

            ! dynamicaly adjust dt
            call modify_dt_POC(phi, phi_dt, dt, r_max, r_min, swaps, swaps_max)

            phi = phi + dt*phi_dt
            call self%ket%normalize(phi)
        end do

        call appendState(phi, self%states, self%numberOfStates, self%resolution)        
    end subroutine findState

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
