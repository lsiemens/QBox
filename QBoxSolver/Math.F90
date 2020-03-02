! Math
!
! implement the type BraKet and math functions for Multigrid and QBoxSolver

module Math
    use Types, only: rp
    implicit none
    private

    public :: BraKet, braketConstructor

    type BraKet
        private
        integer :: resolution
        logical :: isPeriodicBoundary
        real(rp) :: dx
    contains
        procedure :: initalize
        procedure, public :: boundaryCondition, laplacian
        procedure, public :: expectationValue, normalize, orthogonalize
        procedure, public :: innerProduct
    end type BraKet
contains
    function braketConstructor(resolution, isPeriodicBoundary, dx)
        implicit none
        integer, intent(IN) :: resolution
        logical, intent(IN) :: isPeriodicBoundary
        real(rp), intent(IN) :: dx
        type(BraKet) :: braketConstructor

        call braketConstructor%initalize(resolution, isPeriodicBoundary, dx)
    end function braketConstructor

    ! initaliz an instance of type BraKet
    subroutine initalize(self, resolution, isPeriodicBoundary, dx)
        implicit none
        integer, intent(IN) :: resolution
        logical, intent(IN) :: isPeriodicBoundary
        real(rp), intent(IN) :: dx
        class(BraKet) :: self

        self%resolution = resolution
        self%isPeriodicBoundary = isPeriodicBoundary
        self%dx = dx
    end subroutine initalize

    ! apply the boundary condition to phi. If isPeriodicBoundary is false,
    ! then apply the condition that phi is zero at the border, if it is
    ! not false then do not change phi. When phi is left unchanged the use
    ! of the function "cshift" (cyclic shift) in the implementation of the
    ! laplacian will lead to a natural periodic boundary condition.
    subroutine boundaryCondition(self, phi)
        implicit none
        real(rp), dimension(:, :), intent(INOUT) :: phi
        class(BraKet) :: self

        if (.not. self%isPeriodicBoundary) then
            phi(:, 1) = 0.0_rp
            phi(:, self%resolution) = 0.0_rp
            phi(1, :) = 0.0_rp
            phi(self%resolution, :) = 0.0_rp
        end if
    end subroutine boundaryCondition

    function laplacian(self, phi)
        implicit none
        real(rp), dimension(:, :), intent(IN) :: phi
        class(BraKet) :: self
        real(rp), dimension(:, :), allocatable :: laplacian
        
        laplacian = (cshift(phi, shift=1, dim=1) + cshift(phi, shift=-1, dim=1) & 
                   + cshift(phi, shift=1, dim=2) + cshift(phi, shift=-1, dim=2) - 4*phi)/(self%dx**2)
    end function laplacian

    subroutine normalize(self, phi)
        implicit none
        real(rp), dimension(:, :), intent(INOUT) :: phi
        class(BraKet) :: self

        phi = phi/sqrt(self%expectationValue(phi))
    end subroutine normalize

    ! modified Gram Shmidt orthonormalization
    subroutine orthogonalize(self, phi, states, numberOfStates)
        implicit none
        real(rp), dimension(:, :), intent(INOUT) :: phi
        real(rp), dimension(:, :, :), intent(IN) :: states
        integer, intent(IN) :: numberOfStates
        class(BraKet) :: self

        integer :: i

        do i = 1, numberOfStates
            phi = phi - self%innerProduct(phi, states(i, :, :))*states(i, :, :)
        end do
        call self%normalize(phi)
    end subroutine orthogonalize

    function expectationValue(self, phi)
        implicit none
        real(rp), dimension(:, :), intent(IN) :: phi
        class(BraKet) :: self

        real(rp) :: expectationValue

!        expectationValue = sum(phi**2)*self%dx**2
        expectationValue = self%innerproduct(phi, phi)
    end function expectationValue

    function innerProduct(self, phi, psi)
        implicit none
        real(rp), dimension(:, :), intent(IN) :: phi, psi
        class(BraKet) :: self
        real(rp) :: innerProduct

        innerProduct = sum(phi*psi)*self%dx**2
    end function innerProduct
end module Math
