

program fqbox
    use HDF5
    use ISO_C_BINDING, only: C_PTR, C_LOC
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
    integer(HID_T) :: space_id, memory_id
    integer(HID_T) :: dset_id
    integer(HID_T) :: plist_id ! Property list

    integer :: resolution, numberOfStates, iterations=10000
!    integer, parameter :: resolution=64, numberOfStates=3, iterations=10000
    integer, target :: rinbuffer

    real(dp), dimension(:, :, :), allocatable :: data
!    real(dp), dimension(numberOfStates, resolution, resolution) :: data
    integer(HSIZE_T), dimension(3) :: ddims ! = (/numberOfStates, resolution, resolution/)
    integer(HSIZE_T), dimension(1) :: sdims ! = (/0/)
    integer(HSIZE_T), dimension(3) :: cdims ! = (/1, resolution, resolution/) ! chunk size
    integer(HSIZE_T), dimension(3) :: size, offset, count
    integer :: drank=3

    integer :: error ! Error flag

    TYPE(C_PTR) :: bufferPtr
    integer, target :: buffer
    real(dp), dimension(:, :, :), allocatable, target :: bufferArray

    real(dp) :: dt=0.1_dp
    real(dp), dimension(:, :), allocatable :: phi, grad, V

    integer :: i, j, k
    


#ifdef HDF5_F90
    print *,"HDF5 must be compiled with fortran2003 flags"
#endif
    
    call h5open_f(error)
     call h5fopen_f(filename, H5F_ACC_RDWR_F, file_id, error)
      call h5gopen_f(file_id, group_run0, group_id, error)

       ! --------------------- Attributes

!       call h5screate_f(H5S_SCALAR_F, space_id, error)
        call h5aopen_f(group_id, attr_resolution, attr_id, error)
         bufferPtr = C_LOC(buffer)
         call h5aread_f(attr_id, H5T_NATIVE_INTEGER, bufferPtr, error)
         resolution = buffer
        call h5aclose_f(attr_id, error)
        call h5aopen_f(group_id, attr_numberOfStates, attr_id, error)
         bufferPtr = C_LOC(buffer)
         call h5aread_f(attr_id, H5T_NATIVE_INTEGER, bufferPtr, error)
         numberOfStates = buffer
        call h5aclose_f(attr_id, error)
!       call h5sclose_f(space_id, error)


        print *, resolution, numberOfStates
        allocate(bufferArray(numberOfStates, resolution, resolution))
        allocate(data(numberOfStates + 3, resolution, resolution))


       ! -------------------- Data set

!       call h5screate_simple_f(drank, ddims, space_id, error)
!        call h5pcreate_f(H5P_DATASET_CREATE_F, plist_id, error)
!         call h5pset_chunk_f(plist_id, drank, cdims, error)
         call h5dopen_f(group_id, dset_states, dset_id, error)
          bufferPtr = C_LOC(bufferArray)
          call h5dread_f(dset_id, h5kind_to_type(dp, H5_REAL_KIND), bufferPtr, error)
          data(:numberOfStates, :, :) = bufferArray
          deallocate(bufferArray)
          
         call h5dclose_f(dset_id, error)
!        call h5pclose_f(plist_id, error)
!       call h5sclose_f(space_id, error)
       
      call h5gclose_f(group_id, error)
     call h5fclose_f(file_id, error)
    call h5close_f(error)



    ! -------------------- PHYSICS --------------------

    allocate(phi(resolution, resolution))
    phi = 1.0_dp

    allocate(grad(resolution, resolution))
    grad = 0.0_dp

    allocate(V(resolution, resolution))
    V = 0.0_dp


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


    call h5open_f(error)
     call h5fopen_f(filename, H5F_ACC_RDWR_F, file_id, error)
      call h5gopen_f(file_id, group_run0, group_id, error)

       ! --------------------- Attributes

        call h5aopen_f(group_id, attr_numberOfStates, attr_id, error)
         buffer = numberOfStates
         bufferPtr = C_LOC(buffer)
         call h5awrite_f(attr_id, H5T_NATIVE_INTEGER, bufferPtr, error)
        call h5aclose_f(attr_id, error)

       ! -------------------- Data set

!       call h5screate_simple_f(drank, ddims, space_id, error)
!        call h5pcreate_f(H5P_DATASET_CREATE_F, plist_id, error)
!         call h5pset_chunk_f(plist_id, drank, cdims, error)
         call h5dopen_f(group_id, dset_states, dset_id, error)

          size = (/numberOfStates, resolution, resolution/)
          call h5dset_extent_f(dset_id, size, error)
          allocate(bufferArray(numberOfStates, resolution, resolution))
          bufferArray = data
          bufferPtr = C_LOC(bufferArray)
          call h5dwrite_f(dset_id, h5kind_to_type(dp, H5_REAL_KIND), bufferPtr, error)
          deallocate(bufferArray)
! ---------- TODO get slicing working so i dont need to rewrite the whole array
          
         call h5dclose_f(dset_id, error)
!        call h5pclose_f(plist_id, error)
!       call h5sclose_f(space_id, error)
       
      call h5gclose_f(group_id, error)
     call h5fclose_f(file_id, error)
    call h5close_f(error)

    
end program fqbox
