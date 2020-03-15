program fqbox
    use HDF5
    use QBHD
    use, intrinsic :: iso_fortran_env
    implicit none

    character(len=*), parameter :: filename = "data.h5"
    character(len=*), parameter :: group_run0 = "Run0"
    character(len=*), parameter ::  attr_resolution = "resolution"
    character(len=*), parameter ::  attr_numberOfStates = "numberOfStates"

    integer, parameter :: resolution=64, numberOfStates=3, iterations=10000

    real(dp), dimension(numberOfStates, resolution, resolution) :: data
    
    integer :: error ! Error flag

    ! -------------------- PHYSICS --------------------
    real(dp) :: dt=0.1_dp
    real(dp), dimension(resolution, resolution) :: phi=1.0_dp, grad=0.0_dp, V=0.0_dp

    integer :: i, j, k
    real(dp) :: dx, x, y

    dx = 2.0_dp/(resolution - 1)    
    do i = 1, resolution
        do j = 1, resolution
            x = i*dx - 1.0_dp
            y = j*dx - 1.0_dp
            V(i, j) = x*x + y*y
        end do
    end do

    phi(1, :) = 0.0_dp
    phi(resolution, :) = 0.0_dp
    phi(:, 1) = 0.0_dp
    phi(:, resolution) = 0.0_dp

    phi = phi/sqrt(sum(phi*phi))

    do i = 1, numberOfStates
        print *, "New state"
        do j = 1, iterations
            do k = 1, i - 1
                phi = phi - sum(data(k,:,:)*phi)*data(k,:,:)
            end do
            grad(2:resolution - 1, 2:resolution - 1) = phi(3:resolution, 2:resolution - 1) &
                                                     + phi(1:resolution - 2, 2:resolution - 1) &
                                                     + phi(2:resolution - 1, 3:resolution) &
                                                     + phi(2:resolution - 1, 1:resolution - 2) &
                                                     - 4*phi(2:resolution - 1, 2:resolution - 1)
            phi = phi + dt*(grad - V*phi)
            phi = phi/sqrt(sum(phi*phi))
        end do
        data(i, :, :) = phi
    end do

    ! ---------------------- PHYSICS END -----------------

    call openFile(filename, error)
    call openRun(group_run0, error)
    call writeRunAttribute(attr_resolution, resolution, error)
    call writeRunAttribute(attr_numberOfStates, numberOfStates, error)
    call writePotential(V, resolution, error)
    call writeStates(data, numberOfStates, resolution, error)
    call closeRun(error)
    call closeFile(error)

end program fqbox

