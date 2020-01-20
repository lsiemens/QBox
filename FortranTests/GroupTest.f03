program fqbox
    use HDF5
    use, intrinsic :: iso_fortran_env
    implicit none
    integer, parameter  :: dp=kind(0.d0)

    character(len=7), parameter :: filename = "data.h5"
    character(len=4), parameter :: group_run0 = "Run0"
    character(len=10), parameter ::  attr_resolution = "resolution"
    character(len=14), parameter ::  attr_numberOfStates = "numberOfStates"
    character(len=6), parameter :: dset_states = "states"

    integer(HID_T) :: file_id
    integer(HID_T) :: group_id
    integer(HID_T) :: attr_id
    integer(HID_T) :: space_id
    integer(HID_T) :: dset_id

    integer, parameter :: resolution=64, numberOfStates=3, iterations=10000

    real(dp), dimension(numberOfStates, resolution, resolution) :: data
    integer(HSIZE_T), dimension(3) :: ddims = (/numberOfStates, resolution, resolution/)
    integer(HSIZE_T), dimension(1) :: sdims = (/0/)
    integer :: drank=3

    integer :: error ! Error flag

    ! -------------------- PHYSICS --------------------
    real(dp) :: dt=0.1_dp
    real(dp), dimension(resolution, resolution) :: phi=1.0_dp, grad=0.0_dp, V=0.0_dp

    integer :: i, j, k
    


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
    
    call h5open_f(error)
     call h5fcreate_f(filename, H5F_ACC_TRUNC_F, file_id, error)
      call h5gcreate_f(file_id, group_run0, group_id, error)

       call h5screate_f(H5S_SCALAR_F, space_id, error)
        call h5acreate_f(group_id, attr_resolution, H5T_NATIVE_INTEGER, space_id, attr_id, error)
         call h5awrite_f(attr_id, H5T_NATIVE_INTEGER, resolution, sdims, error)
        call h5aclose_f(attr_id, error)
        call h5acreate_f(group_id, attr_numberOfStates, H5T_NATIVE_INTEGER, space_id, attr_id, error)
         call h5awrite_f(attr_id, H5T_NATIVE_INTEGER, numberOfStates, sdims, error)
        call h5aclose_f(attr_id, error)
       call h5sclose_f(space_id, error)

       call h5screate_simple_f(drank, ddims, space_id, error)
        call h5dcreate_f(group_id, dset_states, h5kind_to_type(dp, H5_REAL_KIND), space_id, dset_id, error)
         call h5dwrite_f(dset_id, h5kind_to_type(dp, H5_REAL_KIND), data, ddims, error)
        call h5dclose_f(dset_id, error)
       call h5sclose_f(space_id, error)
       
      call h5gclose_f(group_id, error)
     call h5fclose_f(file_id, error)
    call h5close_f(error)
end program fqbox
