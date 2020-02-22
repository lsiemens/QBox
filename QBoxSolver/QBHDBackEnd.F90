! QBox Hierarchical Data back end
!
! Defines a submodule of QBHD that contains subroutines for reading and writeing HDF primetives

submodule (QBHD) QBHDBackEnd
    implicit none
contains
    subroutine readRunAttributeInteger(attribute_name, value, error)
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
    end subroutine readRunAttributeInteger

    subroutine writeRunAttributeInteger(attribute_name, value, error)
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
    end subroutine writeRunAttributeInteger

    subroutine readRunAttributeReal(attribute_name, value, error)
        implicit none
        character(len=*), intent(IN) :: attribute_name
        real(rp), target, intent(OUT) :: value
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
            
            call h5acreate_f(run_id, attribute_name, h5kind_to_type(rp, H5_REAL_KIND), space_id, attribute_id, error)
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
        call h5aread_f(attribute_id, h5kind_to_type(rp, H5_REAL_KIND), buffer_pointer, error)
        if (error /= NOERROR) then
            print *, "ERROR: Failed to read from attribute"
        end if

        call h5aclose_f(attribute_id, error)
        if (error /= NOERROR) then
            print *, "ERROR: Failed to close attribute"
            return
        end if
    end subroutine readRunAttributeReal

    subroutine writeRunAttributeReal(attribute_name, value, error)
        implicit none
        character(len=*), intent(IN) :: attribute_name
        real(rp), target, intent(IN) :: value
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
            
            call h5acreate_f(run_id, attribute_name, h5kind_to_type(rp, H5_REAL_KIND), space_id, attribute_id, error)
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
        call h5awrite_f(attribute_id, h5kind_to_type(rp, H5_REAL_KIND), buffer_pointer, error)
        if (error /= NOERROR) then
            print *, "ERROR: Failed to write from attribute"
        end if

        call h5aclose_f(attribute_id, error)
        if (error /= NOERROR) then
            print *, "ERROR: Failed to close attribute"
            return
        end if
    end subroutine writeRunAttributeReal

    subroutine readDatasetReal(dataset_name, value, numberOfReals, error)
        implicit none
        character(len=*), intent(IN) :: dataset_name
        real(rp), dimension(:), allocatable, target, intent(OUT) :: value
        integer, intent(IN) :: numberOfReals
        integer, intent(OUT) :: error

        type(C_PTR) :: buffer_pointer
        integer(HID_T) :: data_id, space_id, property_id
        integer(HSIZE_T), dimension(1) :: shape, chunk_size, max_size

        if (.not. run_is_open) then
            print *, "ERROR: There is no open run"
            error = -1
            return
        end if

        call h5dopen_f(run_id, dataset_name, data_id, error)
        if (error /= NOERROR) then
            shape = (/numberOfReals/)
            chunk_size = (/128/)
            max_size = chunk_size
            max_size(1) = H5S_UNLIMITED_F
            call h5screate_simple_f(rank(value), shape, space_id, error, max_size)
            call h5pcreate_f(H5P_DATASET_CREATE_F, property_id, error)
            call h5pset_chunk_f(property_id, rank(value), chunk_size, error)

            call h5dcreate_f(run_id, dataset_name, h5kind_to_type(rp, H5_REAL_KIND), space_id, &
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

        allocate(value(numberOfReals))
        buffer_pointer = C_LOC(value)
        call h5dread_f(data_id, h5kind_to_type(rp, H5_REAL_KIND), buffer_pointer, error)
        call h5dclose_f(data_id, error)
    end subroutine readDatasetReal

    subroutine writeDatasetReal(dataset_name, value, numberOfReals, error)
        implicit none
        character(len=*), intent(IN) :: dataset_name
        real(rp), dimension(:), target, intent(IN) :: value
        integer, intent(IN) :: numberOfReals
        integer, intent(OUT) :: error

        type(C_PTR) :: buffer_pointer
        integer(HID_T) :: data_id, space_id, property_id
        integer(HSIZE_T), dimension(1) :: shape, chunk_size, max_size

        if (.not. run_is_open) then
            print *, "ERROR: There is no open run"
            error = -1
            return
        end if

        call h5dopen_f(run_id, dataset_name, data_id, error)
        if (error /= NOERROR) then
            shape = (/numberOfReals/)
            chunk_size = (/128/)
            max_size = chunk_size
            max_size(1) = H5S_UNLIMITED_F
            call h5screate_simple_f(rank(value), shape, space_id, error, max_size)
            call h5pcreate_f(H5P_DATASET_CREATE_F, property_id, error)
            call h5pset_chunk_f(property_id, rank(value), chunk_size, error)

            call h5dcreate_f(run_id, dataset_name, h5kind_to_type(rp, H5_REAL_KIND), space_id, &
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
        call h5dwrite_f(data_id, h5kind_to_type(rp, H5_REAL_KIND), buffer_pointer, error)
        call h5dclose_f(data_id, error)
    end subroutine writeDatasetReal

    subroutine appendDatasetReal(dataset_name, value, numberOfReals, error)
        implicit none
        character(len=*), intent(IN) :: dataset_name
        real(rp), intent(IN) :: value
        integer, intent(IN) :: numberOfReals
        integer, intent(OUT) :: error

        integer(HID_T) :: dset_id
        integer(HSIZE_T), dimension(1) :: size
        real(rp), dimension(:), allocatable :: data, data_temp
        
        if (.not. run_is_open) then
            print *, "ERROR: There is no open run"
            error = -1
            return
        end if

        call readDatasetReal(dataset_name, data, numberOfReals, error)

        allocate(data_temp(numberOfReals + 1))
        data_temp(:numberOfReals) = data(:)
        data_temp(numberOfReals + 1) = value
        call move_alloc(data_temp, data)

        call h5dopen_f(run_id, dataset_name, dset_id, error)
        size = (/numberOfReals + 1/)
        call h5dset_extent_f(dset_id, size, error)
        call h5dclose_f(dset_id, error)

        call writeDatasetReal(dataset_name, data, numberOfReals + 1, error)
    end subroutine appendDatasetReal

    subroutine readDatasetField(dataset_name, value, numberOfFields, resolution, error)
        implicit none
        character(len=*), intent(IN) :: dataset_name
        real(rp), dimension(:, :, :), allocatable, target, intent(OUT) :: value
        integer, intent(IN) :: numberOfFields, resolution
        integer, intent(OUT) :: error

        type(C_PTR) :: buffer_pointer
        integer(HID_T) :: data_id, space_id, property_id
        integer(HSIZE_T), dimension(3) :: shape, chunk_size, max_size

        if (.not. run_is_open) then
            print *, "ERROR: There is no open run"
            error = -1
            return
        end if

        call h5dopen_f(run_id, dataset_name, data_id, error)
        if (error /= NOERROR) then
            shape = (/numberOfFields, resolution, resolution/)
            chunk_size = (/1, resolution, resolution/)
            max_size = chunk_size
            max_size(1) = H5S_UNLIMITED_F
            call h5screate_simple_f(rank(value), shape, space_id, error, max_size)
            call h5pcreate_f(H5P_DATASET_CREATE_F, property_id, error)
            call h5pset_chunk_f(property_id, rank(value), chunk_size, error)

            call h5dcreate_f(run_id, dataset_name, h5kind_to_type(rp, H5_REAL_KIND), space_id, &
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

        allocate(value(numberOfFields, resolution, resolution))
        buffer_pointer = C_LOC(value)
        call h5dread_f(data_id, h5kind_to_type(rp, H5_REAL_KIND), buffer_pointer, error)
        call h5dclose_f(data_id, error)
    end subroutine readDatasetField

    subroutine writeDatasetField(dataset_name, value, numberOfFields, resolution, error)
        implicit none
        character(len=*), intent(IN) :: dataset_name
        real(rp), dimension(:, :, :), target, intent(IN) :: value
        integer, intent(IN) :: numberOfFields, resolution
        integer, intent(OUT) :: error

        type(C_PTR) :: buffer_pointer
        integer(HID_T) :: data_id, space_id, property_id
        integer(HSIZE_T), dimension(3) :: shape, chunk_size, max_size

        if (.not. run_is_open) then
            print *, "ERROR: There is no open run"
            error = -1
            return
        end if

        call h5dopen_f(run_id, dataset_name, data_id, error)
        if (error /= NOERROR) then
            shape = (/numberOfFields, resolution, resolution/)
            chunk_size = (/1, resolution, resolution/)
            max_size = chunk_size
            max_size(1) = H5S_UNLIMITED_F
            call h5screate_simple_f(rank(value), shape, space_id, error, max_size)
            call h5pcreate_f(H5P_DATASET_CREATE_F, property_id, error)
            call h5pset_chunk_f(property_id, rank(value), chunk_size, error)

            call h5dcreate_f(run_id, dataset_name, h5kind_to_type(rp, H5_REAL_KIND), space_id, &
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
        call h5dwrite_f(data_id, h5kind_to_type(rp, H5_REAL_KIND), buffer_pointer, error)
        call h5dclose_f(data_id, error)
    end subroutine writeDatasetField

    subroutine appendDatasetField(dataset_name, value, numberOfFields, resolution, error)
        implicit none
        character(len=*), intent(IN) :: dataset_name
        real(rp), dimension(:, :), intent(IN) :: value
        integer, intent(IN) :: numberOfFields, resolution
        integer, intent(OUT) :: error

        integer(HID_T) :: dset_id
        integer(HSIZE_T), dimension(3) :: size
        real(rp), dimension(:, :, :), allocatable :: data, data_temp
        
        if (.not. run_is_open) then
            print *, "ERROR: There is no open run"
            error = -1
            return
        end if

        call readDatasetField(dataset_name, data, numberOfFields, resolution, error)

        allocate(data_temp(numberOfFields + 1, resolution, resolution))
        data_temp(:numberOfFields, :, :) = data(:, :, :)
        data_temp(numberOfFields + 1, :, :) = value(:, :)
        call move_alloc(data_temp, data)

        call h5dopen_f(run_id, dataset_name, dset_id, error)
        size = (/numberOfFields + 1, resolution, resolution/)
        call h5dset_extent_f(dset_id, size, error)
        call h5dclose_f(dset_id, error)

        call writeDatasetField(dataset_name, data, numberOfFields + 1, resolution, error)
    end subroutine appendDatasetField
end submodule QBHDBackEnd
