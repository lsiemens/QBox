! QBox Hierarchical Data
!
! Defines subroutines for reading and writing QBox data to HDF5 files.
! 
! The HDF5 created by these routines should have the folowing structure

!
! file_name : file
!     |
!     run_name : HDF5 Group
!        |
!        maxNumberOfStates, numberOfStates : Integer HDF5 Attribute
!        resolution, numberOfGrids : Integer HDF5 Attribute
!        length, mass, targetEvolutionTime : Real HDF5 Attribute
!        isPeriodicBoundary : Logical HDF5 Attribute
!        states : 3D HDF5 Dataset
!        potential : 2D HDF5 Dataset
!        energyLevels : 1D HDF5 Dataset

module QBHD
    use HDF5
    use ISO_C_BINDING, only: C_PTR, C_LOC
    use Types, only: rp
    implicit none
    private

    integer, parameter :: NOERROR=0
    integer(HID_T) :: file_id, run_id
    logical :: file_is_open=.false., run_is_open=.false.

    public :: openFile, closeFile, openRun, closeRun
    public :: readMaxNumberOfStates, writeMaxNumberOfStates
    public :: readNumberOfStates, writeNumberOfStates
    public :: readResolution, writeResolution
    public :: readNumberOfGrids, writeNumberOfGrids
    public :: readTargetEvolutionTime, writeTargetEvolutionTime
    public :: readIsPeriodicBoundary, writeIsPeriodicBoundary
    public :: readLength, writeLength
    public :: readMass, writeMass
    public :: readPotential, writePotential
    public :: readStates, writeStates, appendState
    public :: readEnergyLevels, writeEnergyLevels, appendEnergyLevel

    interface
        module subroutine readRunAttributeInteger(attribute_name, value, error)
            implicit none
            character(len=*), intent(IN) :: attribute_name
            integer, target, intent(OUT) :: value
            integer, intent(OUT) :: error
        end subroutine readRunAttributeInteger

        module subroutine writeRunAttributeInteger(attribute_name, value, error)
            implicit none
            character(len=*), intent(IN) :: attribute_name
            integer, target, intent(IN) :: value
            integer, intent(OUT) :: error
        end subroutine writeRunAttributeInteger

        module subroutine readRunAttributeLogical(attribute_name, value, error)
            implicit none
            character(len=*), intent(IN) :: attribute_name
            logical, intent(OUT) :: value
            integer, intent(OUT) :: error
        end subroutine readRunAttributeLogical

        module subroutine writeRunAttributeLogical(attribute_name, value, error)
            implicit none
            character(len=*), intent(IN) :: attribute_name
            logical, intent(IN) :: value
            integer, intent(OUT) :: error
        end subroutine writeRunAttributeLogical

        module subroutine readRunAttributeReal(attribute_name, value, error)
            implicit none
            character(len=*), intent(IN) :: attribute_name
            real(rp), target, intent(OUT) :: value
            integer, intent(OUT) :: error
        end subroutine readRunAttributeReal

        module subroutine writeRunAttributeReal(attribute_name, value, error)
            implicit none
            character(len=*), intent(IN) :: attribute_name
            real(rp), target, intent(IN) :: value
            integer, intent(OUT) :: error
        end subroutine writeRunAttributeReal

        module subroutine readDatasetReal(dataset_name, value, numberOfReals, error)
            implicit none
            character(len=*), intent(IN) :: dataset_name
            real(rp), dimension(:), allocatable, target, intent(OUT) :: value
            integer, intent(IN) :: numberOfReals
            integer, intent(OUT) :: error
        end subroutine readDatasetReal

        module subroutine writeDatasetReal(dataset_name, value, numberOfReals, error)
            implicit none
            character(len=*), intent(IN) :: dataset_name
            real(rp), dimension(:), target, intent(IN) :: value
            integer, intent(IN) :: numberOfReals
            integer, intent(OUT) :: error
        end subroutine writeDatasetReal
        
        module subroutine appendDatasetReal(dataset_name, value, numberOfReals, error)
            implicit none
            character(len=*), intent(IN) :: dataset_name
            real(rp), intent(IN) :: value
            integer, intent(IN) :: numberOfReals
            integer, intent(OUT) :: error
        end subroutine appendDatasetReal

        module subroutine readDatasetField(dataset_name, value, numberOfFields, resolution, error)
            implicit none
            character(len=*), intent(IN) :: dataset_name
            real(rp), dimension(:, :, :), allocatable, target, intent(OUT) :: value
            integer, intent(IN) :: numberOfFields, resolution
            integer, intent(OUT) :: error
        end subroutine readDatasetField

        module subroutine writeDatasetField(dataset_name, value, numberOfFields, resolution, error)
            implicit none
            character(len=*), intent(IN) :: dataset_name
            real(rp), dimension(:, :, :), target, intent(IN) :: value
            integer, intent(IN) :: numberOfFields, resolution
            integer, intent(OUT) :: error
        end subroutine writeDatasetField

        module subroutine appendDatasetField(dataset_name, value, numberOfFields, resolution, error)
            implicit none
            character(len=*), intent(IN) :: dataset_name
            real(rp), dimension(:, :), intent(IN) :: value
            integer, intent(IN) :: numberOfFields, resolution
            integer, intent(OUT) :: error
        end subroutine appendDatasetField
    end interface

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

    subroutine readMaxNumberOfStates(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "maxNumberOfStates"
        integer, target, intent(OUT) :: value
        integer, intent(OUT) :: error

        call readRunAttributeInteger(attribute_name, value, error)
    end subroutine readMaxNumberOfStates

    subroutine writeMaxNumberOfStates(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "maxNumberOfStates"
        integer, target, intent(IN) :: value
        integer, intent(OUT) :: error

        call writeRunAttributeInteger(attribute_name, value, error)
    end subroutine writeMaxNumberOfStates

    subroutine readNumberOfStates(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "numberOfStates"
        integer, target, intent(OUT) :: value
        integer, intent(OUT) :: error

        call readRunAttributeInteger(attribute_name, value, error)
    end subroutine readNumberOfStates

    subroutine writeNumberOfStates(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "numberOfStates"
        integer, target, intent(IN) :: value
        integer, intent(OUT) :: error

        call writeRunAttributeInteger(attribute_name, value, error)
    end subroutine writeNumberOfStates

    subroutine readResolution(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "resolution"
        integer, target, intent(OUT) :: value
        integer, intent(OUT) :: error

        call readRunAttributeInteger(attribute_name, value, error)
    end subroutine readResolution

    subroutine writeResolution(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "resolution"
        integer, target, intent(IN) :: value
        integer, intent(OUT) :: error

        call writeRunAttributeInteger(attribute_name, value, error)
    end subroutine writeResolution

    subroutine readNumberOfGrids(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "numberOfGrids"
        integer, target, intent(OUT) :: value
        integer, intent(OUT) :: error

        call readRunAttributeInteger(attribute_name, value, error)
    end subroutine readNumberOfGrids

    subroutine writeNumberOfGrids(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "numberOfGrids"
        integer, target, intent(IN) :: value
        integer, intent(OUT) :: error

        call writeRunAttributeInteger(attribute_name, value, error)
    end subroutine writeNumberOfGrids

    subroutine readTargetEvolutionTime(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "targetEvolutionTime"
        real(rp), target, intent(OUT) :: value
        integer, intent(OUT) :: error

        call readRunAttributeReal(attribute_name, value, error)
    end subroutine readTargetEvolutionTime

    subroutine writeTargetEvolutionTime(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "targetEvolutionTime"
        real(rp), target, intent(IN) :: value
        integer, intent(OUT) :: error

        call writeRunAttributeReal(attribute_name, value, error)
    end subroutine writeTargetEvolutionTime




    subroutine readIsPeriodicBoundary(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "isPeriodicBoundary"
        logical, intent(OUT) :: value
        integer, intent(OUT) :: error

        call readRunAttributeLogical(attribute_name, value, error)
    end subroutine readIsPeriodicBoundary

    subroutine writeIsPeriodicBoundary(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "isPeriodicBoundary"
        logical, intent(IN) :: value
        integer, intent(OUT) :: error

        call writeRunAttributeLogical(attribute_name, value, error)
    end subroutine writeIsPeriodicBoundary




    subroutine readLength(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "length"
        real(rp), target, intent(OUT) :: value
        integer, intent(OUT) :: error

        call readRunAttributeReal(attribute_name, value, error)
    end subroutine readLength

    subroutine writeLength(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "length"
        real(rp), target, intent(IN) :: value
        integer, intent(OUT) :: error

        call writeRunAttributeReal(attribute_name, value, error)
    end subroutine writeLength

    subroutine readMass(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "mass"
        real(rp), target, intent(OUT) :: value
        integer, intent(OUT) :: error

        call readRunAttributeReal(attribute_name, value, error)
    end subroutine readMass

    subroutine writeMass(value, error)
        implicit none

        character(len=*), parameter :: attribute_name = "mass"
        real(rp), target, intent(IN) :: value
        integer, intent(OUT) :: error

        call writeRunAttributeReal(attribute_name, value, error)
    end subroutine writeMass

    subroutine readPotential(value, resolution, error)
        implicit none
        character(len=*), parameter :: potential_name = "potential"
        real(rp), dimension(:, :), allocatable, target, intent(OUT) :: value
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
            call h5dcreate_f(run_id, potential_name, h5kind_to_type(rp, H5_REAL_KIND), space_id, data_id, error)
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
        call h5dread_f(data_id, h5kind_to_type(rp, H5_REAL_KIND), buffer_pointer, error)
        call h5dclose_f(data_id, error)
    end subroutine readPotential

    subroutine writePotential(value, resolution, error)
        implicit none
        character(len=*), parameter :: potential_name = "potential"
        real(rp), dimension(:, :), target, intent(IN) :: value
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
            call h5dcreate_f(run_id, potential_name, h5kind_to_type(rp, H5_REAL_KIND), space_id, data_id, error)
            if (error /= NOERROR) then
                print *, "ERROR: Failed to create new data set"
                return
            else
                print *, "WARNING: New data set was created after opening failed"
            end if

            call h5sclose_f(space_id, error)
        end if
        buffer_pointer = C_LOC(value)
        call h5dwrite_f(data_id, h5kind_to_type(rp, H5_REAL_KIND), buffer_pointer, error)
        call h5dclose_f(data_id, error)
    end subroutine writePotential

    subroutine readEnergyLevels(value, numberOfStates, error)
        implicit none

        character(len=*), parameter :: states_name = "energyLevels"
        real(rp), dimension(:), allocatable, target, intent(OUT) :: value
        integer, intent(IN) :: numberOfStates
        integer, intent(OUT) :: error

        call readDatasetReal(states_name, value, numberOfStates, error)
    end subroutine readEnergyLevels

    subroutine writeEnergyLevels(value, numberOfStates, error)
        implicit none

        character(len=*), parameter :: states_name = "energyLevels"
        real(rp), dimension(:), target, intent(IN) :: value
        integer, intent(IN) :: numberOfStates
        integer, intent(OUT) :: error

        call writeDatasetReal(states_name, value, numberOfStates, error)
    end subroutine writeEnergyLevels

    subroutine appendEnergyLevel(value, numberOfStates, error)
        implicit none
        character(len=*), parameter :: states_name = "energyLevels"
        real(rp), intent(IN) :: value
        integer, intent(IN) :: numberOfStates
        integer, intent(OUT) :: error

        call appendDatasetReal(states_name, value, numberOfStates, error)
    end subroutine appendEnergyLevel

    subroutine readStates(value, numberOfStates, resolution, error)
        implicit none

        character(len=*), parameter :: states_name = "states"
        real(rp), dimension(:, :, :), allocatable, target, intent(OUT) :: value
        integer, intent(IN) :: numberOfStates, resolution
        integer, intent(OUT) :: error

        call readDatasetField(states_name, value, numberOfStates, resolution, error)
    end subroutine readStates

    subroutine writeStates(value, numberOfStates, resolution, error)
        implicit none

        character(len=*), parameter :: states_name = "states"
        real(rp), dimension(:, :, :), target, intent(IN) :: value
        integer, intent(IN) :: numberOfStates, resolution
        integer, intent(OUT) :: error

        call writeDatasetField(states_name, value, numberOfStates, resolution, error)
    end subroutine writeStates

    subroutine appendState(value, numberOfStates, resolution, error)
        implicit none
        character(len=*), parameter :: states_name = "states"
        real(rp), dimension(:, :), intent(IN) :: value
        integer, intent(IN) :: numberOfStates, resolution
        integer, intent(OUT) :: error

        call appendDatasetField(states_name, value, numberOfStates, resolution, error)
    end subroutine appendState
end module QBHD
