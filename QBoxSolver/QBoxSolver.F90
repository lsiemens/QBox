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
    type(Grid) :: solver(3)

    call random_seed()

    call initalize()
    solver(3) = gridConstructor(numberOfStates, resolution, length, mass, potential, states)
    call halfStatesResolution(states, numberOfStates, resolution)
    call halfStateResolution(potential, resolution)
    solver(2) = gridConstructor(numberOfStates, resolution/2, length, mass, potential, states)
    call halfStatesResolution(states, numberOfStates, resolution/2)
    call halfStateResolution(potential, resolution/2)
    solver(1) = gridConstructor(numberOfStates, resolution/4, length, mass, potential, states)

    print *, "1"
    deallocate(potential)
    deallocate(states)
    allocate(phi(resolution/4, resolution/4))
    print *, "2"

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

        print *, "3"
        call random_number(phi) ! initalize to random field
        print *, "4"
        call solver(1)%findState(phi, targetEvolutionTime)

        call doubleStateResolution(phi, resolution/4)
        call solver(2)%findState(phi, targetIterations=100)

        call doubleStateResolution(phi, resolution/2)
        call solver(3)%findState(phi, targetIterations=100)

        print *, "5"
        energy = solver(3)%ket%innerProduct(phi, solver(3)%energyOperator(phi))


        print *, "6"
        call openFile(file_name, error)
        call openRun(run_name, error)
          call appendState(phi, numberOfStates, resolution, error)
          call appendEnergyLevel(energy, numberOfStates, error)
          call writeNumberOfStates(numberOfStates + 1, error)
          numberOfStates = numberOfStates + 1
        call closeRun(error)
        call closeFile(error)

        call halfStateResolution(phi, resolution)
        call halfStateResolution(phi, resolution/2)
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

    subroutine doubleStateResolution(phi, resolution)
        real(rp), dimension(:, :), allocatable, intent(INOUT) :: phi
        integer :: resolution
        real(rp), dimension(:, :), allocatable :: phi_temp

        allocate(phi_temp(resolution*2, resolution*2))
        phi_temp(::2, ::2) = phi
        phi_temp(::2, 2::2) = phi
        phi_temp(2::2, ::2) = phi
        phi_temp(2::2, 2::2) = phi
        call move_alloc(phi_temp, phi)
    end subroutine doubleStateResolution

    subroutine halfStateResolution(state, resolution)
        real(rp), dimension(:, :), allocatable, intent(INOUT) :: state
        integer, intent(IN) :: resolution
        real(rp), dimension(:, :), allocatable :: state_temp

        allocate(state_temp(resolution/2, resolution/2))
        state_temp = 0.25_rp*(state(::2, ::2) + state(::2, 2::2) + state(2::2, ::2) + state(2::2, 2::2))
        call move_alloc(state_temp, state)
    end subroutine halfStateResolution

    subroutine halfStatesResolution(states, numberOfStates, resolution)
        real(rp), dimension(:, :, :), allocatable, intent(INOUT) :: states
        integer, intent(IN) :: numberOfStates, resolution
        real(rp), dimension(:, :, :), allocatable :: states_temp

        allocate(states_temp(numberOfStates, resolution/2, resolution/2))
        states_temp = 0.25_rp*(states(:, ::2, ::2) + states(:, ::2, 2::2) + states(:, 2::2, ::2) + states(:, 2::2, 2::2))
        call move_alloc(states_temp, states)
    end subroutine halfStatesResolution
end program QBoxSolver
