program QBoxSolver
    use Types, only: rp, PI
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
    real(rp) :: targetEvolutionTime

    ! ---------------- Physical parameters -----------
    real(rp) :: length, mass
    real(rp), dimension(:, :), allocatable :: potential
    real(rp), dimension(:, :, :), allocatable :: states
    real(rp), dimension(:), allocatable :: energyLevels

    ! ---------------- Assorted parameter ------------
    logical :: stopSolver = .false.
    real(rp), dimension(:, :), allocatable :: phi

    ! ---------------- Measurements ------------------
    real(rp) :: energy

    ! ---------------- Initalize solver --------------
    type(Grid) :: solver

    call initalize()
    solver = gridConstructor(numberOfStates, resolution, length, mass, potential, states)

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

        ! ----------------------- TODO set random seed ---------------
        call random_number(phi) ! initalize to random field
        call solver%findState(phi, targetEvolutionTime)

        energy = solver%ket%innerProduct(phi, solver%energyOperator(phi))

        call openFile(file_name, error)
        call openRun(run_name, error)
          call appendState(phi, numberOfStates, resolution, error)
          call appendEnergyLevel(energy, numberOfStates, error)
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
        real(rp) :: default_length = 2.0_rp, default_mass = 1.0_rp

        call openFile(file_name, error)
        call openRun(run_name, error)

        call readMaxNumberOfStates(maxNumberOfStates, error)
        call readNumberOfStates(numberOfStates, error)
        call readResolution(resolution, error)
        if (resolution <= 0) then
            print *, "WARNING: resolution cannot be zero!"
            print *, "    Setting resolution to the defalt of ", default_resolution
            resolution = default_resolution
            call writeResolution(resolution, error)
        end if
        
        call readLength(length, error)
        if (length <= 0.0_rp) then
            print *, "WARNING: length cannot be zero!"
            print *, "    Setting length to the defalt of ", default_length
            length = default_length
            call writeLength(length, error)
        end if

        call readMass(mass, error)
        if (mass <= 0.0_rp) then
            print *, "WARNING: mass cannot be zero!"
            print *, "    Setting mass to the defalt of ", default_mass
            mass = default_mass
            call writeMass(mass, error)
        end if

        call readTargetEvolutionTime(targetEvolutionTime, error)
        if (targetEvolutionTime <= 0.0_rp) then
            targetEvolutionTime = 8*log(2.0_rp)*mass*length**2/(PI**2) ! delta E of square well target ratio of e^-3
            print *, "WARNING: targetEvolutionTime cannot be zero!"
            print *, "    Setting targetEvolutionTime to the defalt of ", targetEvolutionTime
            print *, "    the default targetEvolutionTime is a function mass and length."
            call writeTargetEvolutionTime(targetEvolutionTime, error)
        end if

        call readPotential(potential, resolution, error)
        call readStates(states, numberOfStates, resolution, error)
        call readEnergyLevels(energyLevels, numberOfStates, error)
        
        call closeRun(error)
        call closeFile(error)
    end subroutine initalize
end program QBoxSolver
