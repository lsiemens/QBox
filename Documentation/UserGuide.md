# QBox: User Guide
Welcome to the user documentation for QBox, simulation software for
solving Schrodinger's equation in two dimensions in real time. In this
documentation I will assume you are familiar with standard concepts and
terminology in quantum mechanics, for a brief introduction to the quantum
mechanics used in QBox and for further reading see [Here (Coming soon)].

## 1. What is QBox
As stated above QBox solves Schrodinger's equation in two dimensions.
In particular this software is based on the eigenvalue problem formulation
of Schrodinger's equation. The energy eigenvalues and eigenstates have
been precomputed for fixed set of potentials which are then used to solve
for the time evolution of arbitrary initial states defined by the user.
In this app for each of the included potentials, the user is able to view
the energy eigenstates, construct the initial wave function and simulate
the time evolution of said initial state.

## 2. Display of Quantum States
As the primary purpose of this app is to view time dependent states, let
us start with the display of quantum states. While the states being
displayed can be energy eigenstates or an arbitrary state evolving
according to the time dependent Schrodinger's equation, how the states are
displayed and the accompanying controls remain the same. A quantum state
has a complex value on each point of the simulation domain, this is
represented visually by one of three display modes that show some aspect
of the state. The display modes are "probability density", "wave function,
real part" and "phase angle", all of which display the state against a
grayscale representation of the potential in the background.

### 2.1. Display Modes
In the "Probability Density" display mode the probability density of
the state is represented by the brightness in the red channel. In the
"Real Part" display mode the real part of the state is represented,
where positive values are shown as brightness in the [red channel ?] and
negative values are shown as brightness in the [green channel]. In the
"Phase Angle" display mode both the magnitude and the phase angle of the
state is represented. The phase angle is shown as the hue and the
magnitude is shown as the brightness.

### 2.2. Gesture Controls
The display mode can be changed by double tapping on the screen, this
will cycle through the modes in the order given above. The brightness of
the modes can be changed by swiping left and right, this can be used to
view details in a low intensity region or to avoid clipping. Swiping
right increases the brightness and swiping left decrease the brightness. 

## 3. Program Modes
QBox has two modes of operation "Steady States" and "Simulation". The
buttons to switch the program mode are on the left side of the screen
and the current program mode is highlighted in green. Note that in
simulation mode the user is first asked to set the initial wave function
before running the simulation, when the simulation pressing the "Simulation"
mode button will reset the simulation and return to the initial wave
function selection screen.

### 3.1. Mode: Steady States
This mode allows the user to view all of the energy eigenstates that have
been loaded for the current potential. When this mode is activated it
starts out on the ground state, then swiping up switch the state being
displayed to the next excited state and swiping down will switch it to the
next lower state. Note that swiping up when at the last loaded state will
do nothing, likewise for swiping down when at the ground state.

### 3.2. Mode: Simulation
This mode has two parts, first the user is presented with option for setting
the initial state to simulate. After pressing the "Run" button the initial
state will evolve according to the time dependent Schrodinger's equation.

#### 3.2.1 Set initial state
When defining the initial state, the user is presented with some options
for constructing the state "Gaussian" and "Color Wheel". When finished
with one of these tools the user can keep using these tools to add more
components to the initial state and when finished press the "Run" button
to continue to the simulation. When using the tools the current initial
state is hidden until the user is finished with the tool.

##### Gaussian
This tool is used to add a Gaussian function to the initial state. The
width of the Gaussian and a speed multiplier are set with the sliders. To
change the position and velocity of the Gaussian press the "Set Position"
button then press and drag on the screen. The location of the Gaussian is
set to where the screen is first pressed and the velocity vector starts
at where the the user releases the screen and ends at the centre of the
Gaussian. All else aside when running the simulation the Gaussian will
move away from the direction in which the screen was dragged with a speed
proportional to the distance it was dragged. When changing any of these
settings a low resolution version of the Gaussian is shown temporarily so
the controls can be more responsive. The following are a few tips,

- Avoid placing the Gaussian where the potential is changing rapidly, these
  configurations require height energy states and will introduce lots of noise

- Use either the "Real Part" or "Phase Angle" display mode when setting
  the velocity, the periodic changes in phase angle visible with these
  modes makes it easier to judge direction and velocity

- It can be useful to set the position and velocity direction first and
  then using the "Speed" slider to fine tune the speed afterwards.

##### Color Wheel

#### 3.2.2 Running simulation
After pressing the "Run" button the simulation will begin. Pressing
"Run Settings" provides options to restart the simulation from the
beginning and slider to adjust the simulation speed.

## 4. Menu button
### 4.1. Selecting potentials
### 4.2. options

## 5. Info button


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