program QBoxSolver
    use Types, only: rp
    use QBHD
    use Multigrid, only: Grid, gridConstructor
    implicit none

    ! ---------------- QBHD variables ----------------
    character(len=*), parameter :: file_name = "data.h5"
    character(len=*), parameter :: run_name = "Run0"
    integer :: error

    ! ---------------- Run parameters ----------------
    integer :: numberOfStates, resolution

    ! ---------------- Physical parameters -----------
    real(rp), dimension(:, :), allocatable :: potential
    real(rp), dimension(:, :, :), allocatable :: states

    ! ---------------- Assorted parameter ------------
    logical :: stopSolver = .false.
    real(rp), dimension(:, :), allocatable :: phi

    ! ---------------- Initalize solver --------------
    type(Grid) :: solver

    call initalize()
    print *, "Simulation", resolution, numberOfStates
    solver = gridConstructor(resolution, numberOfStates, potential, states)

    allocate(phi(resolution, resolution))
    do while (.not. stopSolver)
        call solver%findState(phi)
    end do
    

! ---------------- Subprograms -------------------
contains
    
    subroutine initalize()
        implicit none
        integer :: default_resolution = 64

        call openFile(file_name, error)
        call openRun(run_name, error)

        call readResolution(resolution, error)
        call readNumberOfStates(numberOfStates, error)

        if (resolution == 0) then
            print *, "WARNING: resolution cannot be zero!"
            print *, "    Setting resolution to the defalt of ", default_resolution
            resolution = default_resolution
            call writeResolution(resolution, error)
        end if
        
        call readPotential(potential, resolution, error)
        call readStates(states, numberOfStates, resolution, error)
        
        call closeRun(error)
        call closeFile(error)
    end subroutine initalize
end program QBoxSolver
