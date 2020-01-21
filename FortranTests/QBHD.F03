! QBox Hierarchical Data

module QBHD
    use HDF5
    use ISO_C_BINDING, only: C_PTR, C_LOC
    implicit none

    integer, parameter :: NOERROR=0
    integer, parameter :: dp=kind(0.d0)
    integer(HID_T) :: file_id, run_id
    logical :: file_is_open=.false., run_is_open=.false.

    contains
        subroutine openFile(file_name, error)
            implicit none
            character(len=*), intent(IN) :: file_name
            integer, intent(OUT) :: error

            if (file_is_open) then
                print *, "ERROR: A file is already open"
                error = -1
                return
            end if

#ifdef HDF5_F90
            print *, "ERROR: HDF5 must be compiled with fortran2003 flags"
            error = -1
            return
#endif

            call h5open_f(error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to open HDF5 environment"
                return
            end if
            call h5fopen_f(file_name, H5F_ACC_RDWR_F, file_id, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to open file, creating new file"
                call h5fcreate_f(file_name, H5F_ACC_TRUNC_F, file_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new file"
                    return
                else
                    print *, "WARNING: New file was created after opening failed"
                end if
            end if
            file_is_open = .true.
        end subroutine openFile

        subroutine closeFile(error)
            implicit none
            integer, intent(OUT) :: error

            if (.not. file_is_open) then
                print *, "ERROR: There is no open file"
                error = -1
                return
            end if

            call h5fclose_f(file_id, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to close file"
                return
            end if
            call h5close_f(error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to close HDF5 environment"
                return
            end if
            file_is_open = .false.
        end subroutine closeFile

        subroutine openRun(run_name, error)
            implicit none
            character(len=*), intent(IN) :: run_name
            integer, intent(OUT) :: error

            if (.not. file_is_open) then
                print *, "ERROR: There is no open file"
                error = -1
                return
            end if

            if (run_is_open) then
                print *, "ERROR: A run is already open"
                error = -1
                return
            end if

            call h5gopen_f(file_id, run_name, run_id, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to open run, creating new run"
                call h5gcreate_f(file_id, run_name, run_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new run"
                    return
                else
                    print *, "WARNING: New run was created after opening failed"
                end if
            end if
            run_is_open = .true.           
        end subroutine openRun

        subroutine closeRun(error)
            implicit none
            integer, intent(OUT) :: error

            if (.not. file_is_open) then
                print *, "ERROR: There is no open file"
                error = -1
                return
            end if

            if (.not. run_is_open) then
                print *, "ERROR: There is no open run"
                error = -1
                return
            end if

            call h5gclose_f(run_id, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to close run"
                return
            end if
            run_is_open = .false.
        end subroutine closeRun
        
        subroutine readRunAttribute(attribute_name, value, error)
            implicit none
            character(len=*), intent(IN) :: attribute_name
            integer, target, intent(OUT) :: value
            integer, intent(OUT) :: error

            type(C_PTR) :: buffer_pointer
            
            integer(HID_T) :: attribute_id, space_id

            if (.not. run_is_open) then
                print *, "ERROR: There is no open run"
                error = -1
                return
            end if

            call h5aopen_f(run_id, attribute_name, attribute_id, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to open attribute, creating new attribute"
                call h5screate_f(H5S_SCALAR_F, space_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new data space for attribute"
                end if
                
                call h5acreate_f(run_id, attribute_name, H5T_NATIVE_INTEGER, space_id, attribute_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new attribute"
                    return
                else
                    print *, "WARNING: New attribute was created after opening failed"
                end if

                call h5sclose_f(space_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to close data space for attribute"
                end if
            end if

            buffer_pointer = C_LOC(value)
            call h5aread_f(attribute_id, H5T_NATIVE_INTEGER, buffer_pointer, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to read from attribute"
            end if

            call h5aclose_f(attribute_id, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to close attribute"
                return
            end if
        end subroutine readRunAttribute

        subroutine writeRunAttribute(attribute_name, value, error)
            implicit none
            character(len=*), intent(IN) :: attribute_name
            integer, target, intent(IN) :: value
            integer, intent(OUT) :: error

            type(C_PTR) :: buffer_pointer
            
            integer(HID_T) :: attribute_id, space_id

            if (.not. run_is_open) then
                print *, "ERROR: There is no open run"
                error = -1
                return
            end if

            call h5aopen_f(run_id, attribute_name, attribute_id, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to open attribute, creating new attribute"
                call h5screate_f(H5S_SCALAR_F, space_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new data space for attribute"
                end if
                
                call h5acreate_f(run_id, attribute_name, H5T_NATIVE_INTEGER, space_id, attribute_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new attribute"
                    return
                else
                    print *, "WARNING: New attribute was created after opening failed"
                end if

                call h5sclose_f(space_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to close data space for attribute"
                end if
            end if

            buffer_pointer = C_LOC(value)
            call h5awrite_f(attribute_id, H5T_NATIVE_INTEGER, buffer_pointer, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to write from attribute"
            end if

            call h5aclose_f(attribute_id, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to close attribute"
                return
            end if
        end subroutine writeRunAttribute
        
        subroutine readPotential(value, resolution, error)
            implicit none
            character(len=*), parameter :: potential_name = "potential"
            real(dp), dimension(:, :), allocatable, target, intent(OUT) :: value
            integer, intent(IN) :: resolution
            integer, intent(OUT) :: error

            type(C_PTR) :: buffer_pointer
            integer(HID_T) :: data_id, space_id
            integer(HSIZE_T), dimension(2) :: shape

            if (.not. run_is_open) then
                print *, "ERROR: There is no open run"
                error = -1
                return
            end if

            call h5dopen_f(run_id, potential_name, data_id, error)
            if (error /= NOERROR) then
                shape = (/resolution, resolution/)
                call h5screate_simple_f(rank(value), shape, space_id, error)
                call h5dcreate_f(run_id, potential_name, h5kind_to_type(dp, H5_REAL_KIND), space_id, data_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new data set"
                    return
                else
                    print *, "WARNING: New data set was created after opening failed"
                end if

                call h5sclose_f(space_id, error)
            end if
            allocate(value(resolution, resolution))
            buffer_pointer = C_LOC(value)
            call h5dread_f(data_id, h5kind_to_type(dp, H5_REAL_KIND), buffer_pointer, error)
            call h5dclose_f(data_id, error)
        end subroutine readPotential

        subroutine writePotential(value, resolution, error)
            implicit none
            character(len=*), parameter :: potential_name = "potential"
            real(dp), dimension(:, :), target, intent(IN) :: value
            integer, intent(IN) :: resolution
            integer, intent(OUT) :: error

            type(C_PTR) :: buffer_pointer
            integer(HID_T) :: data_id, space_id
            integer(HSIZE_T), dimension(2) :: shape

            if (.not. run_is_open) then
                print *, "ERROR: There is no open run"
                error = -1
                return
            end if

            call h5dopen_f(run_id, potential_name, data_id, error)
            if (error /= NOERROR) then
                shape = (/resolution, resolution/)
                call h5screate_simple_f(rank(value), shape, space_id, error)
                call h5dcreate_f(run_id, potential_name, h5kind_to_type(dp, H5_REAL_KIND), space_id, data_id, error)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new data set"
                    return
                else
                    print *, "WARNING: New data set was created after opening failed"
                end if

                call h5sclose_f(space_id, error)
            end if
            buffer_pointer = C_LOC(value)
            call h5dwrite_f(data_id, h5kind_to_type(dp, H5_REAL_KIND), buffer_pointer, error)
            call h5dclose_f(data_id, error)
        end subroutine writePotential

        subroutine readStates(value, numberOfStates, resolution, error)
            implicit none
            character(len=*), parameter :: states_name = "states"
            real(dp), dimension(:, :, :), allocatable, target, intent(OUT) :: value
            integer, intent(IN) :: numberOfStates, resolution
            integer, intent(OUT) :: error

            type(C_PTR) :: buffer_pointer
            integer(HID_T) :: data_id, space_id, property_id
            integer(HSIZE_T), dimension(3) :: shape, chunk_size, max_size

            if (.not. run_is_open) then
                print *, "ERROR: There is no open run"
                error = -1
                return
            end if

            call h5dopen_f(run_id, states_name, data_id, error)
            if (error /= NOERROR) then
                shape = (/numberOfStates, resolution, resolution/)
                chunk_size = (/1, resolution, resolution/)
                max_size = chunk_size
                max_size(1) = H5S_UNLIMITED_F
                call h5screate_simple_f(rank(value), shape, space_id, error, max_size)
                call h5pcreate_f(H5P_DATASET_CREATE_F, property_id, error)
                call h5pset_chunk_f(property_id, rank(value), chunk_size, error)

                call h5dcreate_f(run_id, states_name, h5kind_to_type(dp, H5_REAL_KIND), space_id, &
                                 data_id, error, dcpl_id=property_id)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new data set"
                    return
                else
                    print *, "WARNING: New data set was created after opening failed"
                end if

                call h5pclose_f(property_id, error)
                call h5sclose_f(space_id, error)
            end if

            allocate(value(numberOfStates, resolution, resolution))
            buffer_pointer = C_LOC(value)
            call h5dread_f(data_id, h5kind_to_type(dp, H5_REAL_KIND), buffer_pointer, error)
            call h5dclose_f(data_id, error)
        end subroutine readStates

        subroutine writeStates(value, numberOfStates, resolution, error)
            implicit none
            character(len=*), parameter :: states_name = "states"
            real(dp), dimension(:, :, :), target, intent(IN) :: value
            integer, intent(IN) :: numberOfStates, resolution
            integer, intent(OUT) :: error

            type(C_PTR) :: buffer_pointer
            integer(HID_T) :: data_id, space_id, property_id
            integer(HSIZE_T), dimension(3) :: shape, chunk_size, max_size

            if (.not. run_is_open) then
                print *, "ERROR: There is no open run"
                error = -1
                return
            end if

            call h5dopen_f(run_id, states_name, data_id, error)
            if (error /= NOERROR) then
                shape = (/numberOfStates, resolution, resolution/)
                chunk_size = (/1, resolution, resolution/)
                max_size = chunk_size
                max_size(1) = H5S_UNLIMITED_F
                call h5screate_simple_f(rank(value), shape, space_id, error, max_size)
                call h5pcreate_f(H5P_DATASET_CREATE_F, property_id, error)
                call h5pset_chunk_f(property_id, rank(value), chunk_size, error)

                call h5dcreate_f(run_id, states_name, h5kind_to_type(dp, H5_REAL_KIND), space_id, &
                                 data_id, error, dcpl_id=property_id)
                if (error /= NOERROR) then
                    print *, "ERROR: Failed to create new data set"
                    return
                else
                    print *, "WARNING: New data set was created after opening failed"
                end if

                call h5pclose_f(property_id, error)
                call h5sclose_f(space_id, error)
            end if

            buffer_pointer = C_LOC(value)
            call h5dwrite_f(data_id, h5kind_to_type(dp, H5_REAL_KIND), buffer_pointer, error)
            call h5dclose_f(data_id, error)
        end subroutine writeStates
                
end module QBHD
