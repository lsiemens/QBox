program fqbox
    implicit none
    integer, parameter  :: dp=kind(0.d0)

    integer, parameter :: res=100, iterations=10000
    real(dp) :: dt=0.1
    real(dp) :: V(res, res)=0.0_dp
    complex(dp) :: phi(res, res)=(1.0_dp, 1.0_dp), a(res, res)=(0.0_dp, 0.0_dp), grad(res, res)=(0.0_dp, 0.0_dp)

    integer :: i1

    phi(1, :) = (0.0_dp, 0.0_dp)
    phi(res, :) = (0.0_dp, 0.0_dp)
    phi(:, 1) = (0.0_dp, 0.0_dp)
    phi(:, res) = (0.0_dp, 0.0_dp)

    phi = phi/sqrt(sum(conjg(phi)*phi))

    do i1 = 1, iterations
        phi = phi - sum(conjg(a)*phi)*a
        grad(2:res - 1, 2:res - 1) = phi(3:res, 2:res - 1) &
                                   + phi(1:res - 2, 2:res - 1) &
                                   + phi(2:res - 1, 3:res) &
                                   + phi(2:res - 1, 1:res - 2) &
                                   - 4*phi(2:res - 1, 2:res - 1)
        phi = phi + dt*(grad - V*phi)
        phi = phi/sqrt(sum(conjg(phi)*phi))
    end do
end program fqbox
