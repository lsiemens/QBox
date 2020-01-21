module Multigrid
    use Types, only: rp
    implicit none
    private

    public :: Grid, gridConstructor
    
    type Grid
        private
        integer :: numberOfStates, resolution
        real(rp), dimension(:, :), allocatable :: potential
        real(rp), dimension(:, :, :), allocatable :: states
    contains
        private
        procedure :: initalize
        procedure, public :: findState
    end type Grid
contains
    function gridConstructor(numberOfStates, resolution, potential, states)
        implicit none
        integer, intent(IN) :: numberOfStates, resolution
        real(rp), dimension(:, :), intent(IN) :: potential
        real(rp), dimension(:, :, :), intent(IN) :: states
        type(grid) :: gridConstructor

        call gridConstructor%initalize(numberOfStates, resolution, potential, states)
    end function gridConstructor

    subroutine initalize(self, numberOfStates, resolution, potential, states)
        implicit none
        integer, intent(IN) :: numberOfStates, resolution
        real(rp), dimension(:, :), intent(IN) :: potential
        real(rp), dimension(:, :, :), intent(IN) :: states
        class(Grid) :: self

        self%numberOfStates = numberOfStates
        self%resolution = resolution
        self%potential = potential
        self%states = states

        print *, numberOfStates, resolution, rank(potential), rank(states)
    end subroutine initalize

    subroutine findState(self, phi)
        implicit none
        real(rp), dimension(:, :), intent(INOUT) :: phi
        class(Grid) :: self

        print *, "try to find State"
        !solve and return phi
        
    end subroutine findState
end module Multigrid
