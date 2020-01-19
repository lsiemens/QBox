module mymod
    type, public :: test
    integer, private :: num

    contains
        procedure, public :: set
        procedure, public :: get
    end type test

    private; contains
    subroutine set(p, num)
        class(test) :: p
        integer :: num
        p%num = num
        write(0,*) "set num"
    end subroutine

    subroutine get(p)
        class(test) :: p
        write(0, *) p%num
    end subroutine
end module

program fqbox
    use HDF5
    use mymod
    use, intrinsic :: iso_fortran_env
    implicit none
    integer, parameter  :: dp=kind(0.d0)

    integer, parameter :: res=6, iterations=100
    real(dp) :: dt=0.1
    real(dp) :: V(res, res)=0.0_dp
    real(dp) :: phi(res, res)=1.0_dp, a(res, res)=0.0_dp, grad(res, res)=0.0_dp
!    complex(dp) :: phi(res, res)=(1.0_dp, 1.0_dp), a(res, res)=(0.0_dp, 0.0_dp), grad(res, res)=(0.0_dp, 0.0_dp)

    integer :: i1

    type(test), allocatable :: x

    CHARACTER(LEN=8), PARAMETER :: filename = "dsetf.h5" ! File name
    CHARACTER(LEN=4), PARAMETER :: dsetname = "dset"     ! Dataset name
    character(len=9), parameter :: aname = "attr_long"   ! Attribute name
    character(len=7), parameter :: groupname = "MyGroup" ! Group name

    INTEGER(HID_T) :: file_id       ! File identifier
    integer(HID_T) :: group_id      ! Group identifier
    INTEGER(HID_T) :: dset_id       ! Dataset identifier
    integer(HID_T) :: attr_id       ! Attribute identifier
    integer(HID_T) :: aspace_id     ! Attribute Dataspace identifier
    integer(HSIZE_T), dimension(1) :: adims = (/2/) ! Attribute dimension
    integer        :: arank = 1                     ! Attribute rank
    integer(SIZE_T) :: attrlen      ! Length of attribute string
    INTEGER(HID_T) :: dspace_id     ! Dataspace identifier

    character(len=80), dimension(2) :: attr_data ! Attribute data


    real(dp), dimension(4, 6) :: view
    INTEGER(HSIZE_T), DIMENSION(2) :: dims = (/4, 6/) ! Dataset dimensions must use unsigned long long HSIZE_T
    INTEGER     ::   rank = 2                        ! Dataset rank

    INTEGER     ::   error ! Error flag

    attr_data(1) = "More dataset attribiute"
    attr_data(2) = "This meta data"
    attrlen = 80

    phi(1, :) = 0.0_dp
    phi(res, :) = 0.0_dp
    phi(:, 1) = 0.0_dp
    phi(:, res) = 0.0_dp

!    phi(1, :) = (0.0_dp, 0.0_dp)
!    phi(res, :) = (0.0_dp, 0.0_dp)
!    phi(:, 1) = (0.0_dp, 0.0_dp)
!    phi(:, res) = (0.0_dp, 0.0_dp)

    phi = phi/sqrt(sum(phi*phi))
!    phi = phi/sqrt(sum(conjg(phi)*phi))

    do i1 = 1, iterations
        phi = phi - sum(a*phi)*a
!        phi = phi - sum(conjg(a)*phi)*a
        grad(2:res - 1, 2:res - 1) = phi(3:res, 2:res - 1) &
                                   + phi(1:res - 2, 2:res - 1) &
                                   + phi(2:res - 1, 3:res) &
                                   + phi(2:res - 1, 1:res - 2) &
                                   - 4*phi(2:res - 1, 2:res - 1)
        phi = phi + dt*(grad - V*phi)
        phi = phi/sqrt(sum(phi*phi))
!        phi = phi/sqrt(sum(conjg(phi)*phi))
    end do

    phi(:2, :2) = 1.0_dp
    phi(:2, :2) = phi(:2, :2)*1.234_dp
    print  *, phi
    view = phi(:4, :6) ! view port that fits the table else there would be indexing errors

    CALL h5open_f(error)
!     CALL h5fcreate_f(filename, H5F_ACC_TRUNC_F, file_id, error)
     call h5fopen_f(filename, H5F_ACC_RDWR_F, file_id, error)
!      CALL h5screate_simple_f(rank, dims, dspace_id, error)
!       CALL h5dcreate_f(file_id, dsetname, h5kind_to_type(dp, H5_REAL_KIND), dspace_id, dset_id, error)
       call h5dopen_f(file_id, dsetname, dset_id, error)
!        call h5screate_simple_f(arank, adims, aspace_id, error)
         call h5tset_size_f(H5T_NATIVE_CHARACTER, attrlen, error)
!         call h5acreate_f(dset_id, aname, H5T_NATIVE_CHARACTER, aspace_id, attr_id, error)
         call h5aopen_f(dset_id, aname, attr_id, error)
          call h5awrite_f(attr_id, H5T_NATIVE_CHARACTER, attr_data, adims, error)
         call h5aclose_f(attr_id, error)
!        call h5sclose_f(aspace_id, error)
        call h5dwrite_f(dset_id, h5kind_to_type(dp, H5_REAL_KIND), view, dims, error)
       CALL h5dclose_f(dset_id, error)
!      CALL h5sclose_f(dspace_id, error)
!      call h5gcreate_f(file_id, groupname, group_id, error)
      call h5gopen_f(file_id, groupname, group_id, error)
      call h5gclose_f(group_id, error)
     CALL h5fclose_f(file_id, error)
    CALL h5close_f(error)

    allocate(x)
    CALL x%set(41)
    CALL x%get()
    
end program fqbox
