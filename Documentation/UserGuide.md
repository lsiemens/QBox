# QBox: User Guide
Welcome to the user documentation for QBox, simulation software for
solving Schrodinger's equation in two dimensions in real time. In this
documentation I will assume you are familiar with standard concepts and
terminology in quantum mechanics, for a brief introduction to the quantum
mechanics used in QBox and for further reading see [Here (Coming soon)].

## What is QBox
As stated above QBox solves Schrodinger's equation in two dimensions.
In particular this software is based on the eigenvalue problem formulation
of Schrodinger's equation. The energy eigenvalues and eigenstates have
been precomputed for fixed set of potentials which are then used to solve
for the time evolution of arbitrary initial states defined by the user.
In this app for each of the included potentials, the user is able to view
the energy eigenstates, construct the initial wave function and simulate
the time evolution of said initial state.

## Display of Quantum States
As the primary purpose of this app is to view time dependent states, let
us start with the display of quantum states. While the states being
displayed can be energy eigenstates or an arbitrary state evolving
according to the time dependent Schrodinger's equation, how the states are
displayed and the accompanying controls remain the same. A quantum state
has a complex value on each point of the simulation domain, this is
represented visually by one of three display modes that show some aspect
of the state. The display modes are "probability density", "wave function,
real part" and "phase angle", all of which display the state against a
gray-scale representation of the potential in the background.

### Probability Density
In this display mode the probability density of the state is represented
and the brightness in the red channel.

### Real Part
In this display mode the real part of the state is represented. Where
positive values are shown as brightness in the [red channel ?] and negative
values are shown as brightness in the [green channel].

### Phase Angle
In this display mode both the magnitude and the phase angle of the state
is represented. The phase angle is shown as the hue and the magnitude is
shown as the brightness.

### Gesture Controls
The display mode can be changed by double tapping on the screen, this
will cycle through the modes. The brightness of the modes can be changed
by swiping left and right, this can be used to view details in a low
intensity region or to avoid clipping. Swiping right increases the
brightness and swiping left decrease the brightness. 

## Program Modes
QBox has two modes of operation "Steady States" and "Simulation". The
buttons to switch the program mode are on the left side of the screen
and the current program mode is highlighted in green. Note that in
simulation mode the user is first asked to set the initial wave function
before running the simulation, when the simulation pressing the "Simulation"
mode button will reset the simulation and return to the initial wave
function selection screen.

## Mode: Steady States

## Mode: Simulation
### Set initial state
#### Gaussian
#### Color Wheel
### Running simulation

## Menu button
### Selecting potentials
### options

## Info button

# Outline
Viewing States
- display modes
    - gestures
Program modes
- Steady States
    - gestures
- Simulation
    - set initial state
    - running simulation
App Options
- selecting potential
- setting number of states
Info
- available information
