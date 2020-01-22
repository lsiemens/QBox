program QBoxSolver
    use Types, only: rp
    use QBHD
    use Multigrid, only: Grid, gridConstructor
    implicit none

    ! ---------------- QBHD variables ----------------
    character(len=*), parameter :: file_name = "data.h5"
    character(len=*), parameter :: run_name = "Run0"
    character(len=*), parameter :: stop_msg = "stop.msg"
    integer :: error

    ! ---------------- Run parameters ----------------
    integer :: numberOfStates, resolution, maxNumberOfStates

    ! ---------------- Physical parameters -----------
    real(rp), dimension(:, :), allocatable :: potential
    real(rp), dimension(:, :, :), allocatable :: states

    ! ---------------- Assorted parameter ------------
    logical :: stopSolver = .false.
    real(rp), dimension(:, :), allocatable :: phi

    ! ---------------- Initalize solver --------------
    type(Grid) :: solver

    call initalize()
    solver = gridConstructor(numberOfStates, resolution, 2.0_rp, 1.0_rp, potential, states)

    deallocate(potential)
    deallocate(states)
    allocate(phi(resolution, resolution))

    do while (.true.)
        if (maxNumberOfStates > 0) then
            if (numberOfStates >= maxNumberOfStates) then
                print *, numberOfStates, "states have been found. This solver will now stop."
                exit
            end if
        else
            inquire(file=stop_msg, exist=stopSolver)
            if (stopSolver) then
                print *, "File stop.msg detected. This solver will now stop."
                exit
            end if
        end if

        call random_number(phi) ! initalize to random field
        call solver%findState(phi)

        call openFile(file_name, error)
        call openRun(run_name, error)
          call appendState(phi, numberOfStates, resolution, error)
          call writeNumberOfStates(numberOfStates + 1, error)
          numberOfStates = numberOfStates + 1
        call closeRun(error)
        call closeFile(error)

        print *, "Found state:", numberOfStates
    end do

! ---------------- Subprograms -------------------
contains
    subroutine initalize()
        implicit none
        integer :: default_resolution = 64

        call openFile(file_name, error)
        call openRun(run_name, error)

        call readResolution(resolution, error)
        call readMaxNumberOfStates(maxNumberOfStates, error)
        call readNumberOfStates(numberOfStates, error)

        ! ---------------- TEMPORARY --------------------
        maxNumberOfStates = 10
        call writeMaxNumberOfStates(maxNumberOfStates, error)

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
