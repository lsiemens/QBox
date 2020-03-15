program fqbox
    use HDF5
    use QBHD
    use ISO_C_BINDING, only: C_PTR, C_LOC
    implicit none

    character(len=*), parameter :: filename = "data.h5"
    character(len=*), parameter :: group_run0 = "Run0"
    character(len=*), parameter ::  attr_resolution = "resolution"
    character(len=*), parameter ::  attr_numberOfStates = "numberOfStates"

    integer(HID_T) :: dset_id

    integer :: resolution, numberOfStates, iterations=10000

    real(dp), dimension(:, :, :), allocatable :: data, data_temp
    integer(HSIZE_T), dimension(3) :: size

    integer :: error ! Error flag

    real(dp) :: dt=0.1_dp
    real(dp), dimension(:, :), allocatable :: phi, grad, V

    integer :: i, j, k

    call openFile(filename, error)
    call openRun(group_run0, error)

    call readRunAttribute(attr_resolution, resolution, error)
    call readRunAttribute(attr_numberOfStates, numberOfStates, error)
    call readPotential(V, resolution, error)
    call readStates(data, numberOfStates, resolution, error)

    call closeRun(error)
    call closeFile(error)

    allocate(data_temp(numberOfStates + 3, resolution, resolution))
    data_temp(:numberOfStates, :, :) = data(:, :, :)
    call move_alloc(data_temp, data)

    ! -------------------- PHYSICS --------------------

    allocate(phi(resolution, resolution))
    phi = 1.0_dp

    allocate(grad(resolution, resolution))
    grad = 0.0_dp


    phi(1, :) = 0.0_dp
    phi(resolution, :) = 0.0_dp
    phi(:, 1) = 0.0_dp
    phi(:, resolution) = 0.0_dp

    phi = phi/sqrt(sum(phi*phi))

    do i = 1, 3! numberOfStates
        do j = 1, iterations
            do k = 1, numberOfStates + i - 1
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
        data(numberOfStates + i, :, :) = phi
    end do

    numberOfStates = numberOfStates + 3

    ! ---------------------- PHYSICS END -----------------

    call openFile(filename, error)
    call openRun(group_run0, error)

    call writeRunAttribute(attr_resolution, resolution, error)
    call writeRunAttribute(attr_numberOfStates, numberOfStates, error)
    call writePotential(V, resolution, error)

    call appendState(data(numberOfStates - 2, :, :), numberOfStates - 3, resolution, error)
    call appendState(data(numberOfStates - 1, :, :), numberOfStates - 2, resolution, error)
    call appendState(data(numberOfStates, :, :), numberOfStates - 1, resolution, error)

    call closeRun(error)
    call closeFile(error)
    
end program fqbox
