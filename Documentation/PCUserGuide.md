---
layout: page
title: "QBox: PC User Guide"
date: 2020-01-01
---
Welcome to the user documentation for QBox, simulation software for
solving Schrödinger's equation in two dimensions in real time. In this
documentation I will assume you are familiar with standard concepts and
terminology in quantum mechanics. For a brief introduction to the quantum
mechanics used in QBox and for further reading see [Coming soon].

## 1. What is QBox
As stated above QBox solves Schrödinger's equation in two dimensions. In
particular this software is based on the eigenvalue problem formulation
of Schrödinger's equation. The energy eigenvalues and eigenstates have
been precomputed for a fixed set of potentials which are then used to
solve for the time evolution of arbitrary initial states defined by the
user. In this app for each of the included potentials, the user is able
to view the energy eigenstates, construct the initial wave function and
simulate the time evolution of said initial state.

## 2. Display of Quantum States
As the primary purpose of this app is to view time dependent states, let
us start with the display of quantum states. While the states being
displayed can be energy eigenstates or an arbitrary state evolving
according to the time dependent Schrödinger's equation, how the states
are displayed and the accompanying controls remain the same. A quantum
state has a complex value on each point of the simulation domain. This
is represented visually by one of three display modes that show some
aspect of the state. The display modes are "Probability Density",
"Real Part", "Imaginary Part" and "Phase Angle", all of which display the
state against a grayscale representation of the potential in the background.

### 2.1. Display Modes
In the "Probability Density" display mode the probability density of the
state is represented by the brightness in the red channel. In the
"Real Part" and "Imaginary Part" display modes the corresponding of the
complex state is represented, where positive values are shown as brightness
in the red channel and negative values are shown as brightness in the
green channel. In the "Phase Angle" display mode both the magnitude and
the phase angle of the state is represented. The phase angle is shown as
the hue and the magnitude is shown as the brightness.

### 2.2. Display Controls
The display mode can be changed pressing the tab key. This will cycle
through the modes in the order given above. The brightness of the modes
can be changed by holding down the + or - keys, this can be used to view
details in a low intensity region or to avoid clipping.

## 3. Program Modes
QBox has two modes of operation, "Steady States" and "Simulation". The
buttons to switch the program mode are on the left side of the screen
and the current program mode is highlighted in green. Note that in
simulation mode the user is first asked to set the initial wave function
before running the simulation. Pressing the "Simulation" mode button will
reset the simulation and return to the initial wave function selection screen.

### 3.1. Mode: Steady States
This mode allows the user to view all of the energy eigenstates that have
been loaded for the current potential. When this mode is activated it
starts out on the ground state, then pressing the up arrow key switches
the state being displayed to the next excited state and pressing the down
arrow key will switch it to the next lower state. Note that pressing the
up arrow key when at the last loaded state will do nothing, likewise for
pressing the down arrow key when at the ground state.

### 3.2. Mode: Simulation
This mode has two parts, first the user is presented with an option for
setting the initial state to simulate. Second, after pressing the "Run"
button the initial state will evolve according to the time dependent
Schrödinger's equation.

#### 3.2.1 Initial State
When defining the initial state, the user is presented with some options
for constructing the state "Gaussian" and "Color Wheel". When finished
with one of these tools, the user can keep using these tools to add more
components to the initial state, and when finished the user can press the
"Run" button to continue to the simulation. When using the tools, the
current initial state is hidden until the user is finished with the tool.

##### Gaussian
This tool is used to add a Gaussian function to the initial state. The
width of the Gaussian and the speed multiplier are set with the sliders.
To change the position and velocity of the Gaussian press the "Set Position"
button, then left click and drag on the screen. The location of the Gaussian
is set to where the mouse button is first pressed and the velocity vector
starts at where the user releases the mouse button and ends at the center
of the Gaussian. All else aside when running the simulation the Gaussian
will move away from the direction in which the mouse was dragged with a
speed proportional to the distance that it was dragged. When changing any
of these settings a low resolution version of the Gaussian is shown
temporarily so the controls can be more responsive. The following are a
few tips:

- Avoid placing the Gaussian where the potential is changing rapidly. These
  configurations require high energy states and will introduce lots of noise

- Use either the "Real Part" or "Phase Angle" display mode when setting
  the velocity. The periodic changes in phase angle visible with these
  modes makes it easier to judge direction and velocity

- It can be useful to set the position and velocity direction first, and
  then use the "Speed" slider to fine tune the speed afterwards.

##### Color Wheel
This tool is used to add a superposition of energy eigenstates to the
initial state. The superposition is constructed by getting the user to
select the probability amplitude of the individual energy eigenstates.
The selection starts with the probability amplitude for the ground state
and then after each selection it moves to the next excited state. The
interface for selecting a probability amplitude consists of a color wheel
where clicking on a point in the wheel determines the phase and magnitude
of the probability amplitude. The differences in hue around the color
wheel indicate the phase while the distance out from the center indicates
the magnitude. One catch is that when the user has finished selecting the
states it should be normalized, so in the process of selecting the states
the sum of squared amplitudes must not exceed a value of one. To enforce
this condition the wheel splits into two portions by radius. Out side of
this radius the wheel is switched to grayscale and clicking here does
nothing. The radius of the selectable region of the color wheel indicates
the maximum magnitude that is allowed given the previous selections. If
the user keeps selecting states until the colored region goes to zero,
then the set of selections is necessarily normalized. However, if the
user exits the editor before this point, then the set of probability
amplitudes will be normalized before adding it to the initial state.

#### 3.2.2 Simulation
After pressing the "Run" button the simulation will begin. Pressing
"Run Settings" provides options to restart the simulation from the
beginning and a slider to adjust the simulation speed.

## 4. Menu button
From the "Menu" button the user can access the potential selection menu,
the options menu and open the documentation. From the "Select Potential"
menu the user can select from one of the precomputed potentials. Clicking
on one of the options will load the selected potential along with the
energy eigenvalues and eigenstates. From the "Options" menu the user can
reset the dialogue boxes and set the number of states to be loaded. Clicking
the "Exit" button will close QBox.

## 5. Info button
Pressing the "Info" button opens a window on the lower portion of the
screen with some information about the display, simulation settings and
the current state shown on screen. This information includes:

- Potential: Name of the currently selected potential
- Display Mode: Name of the active display mode
- Expected Energy: The expected value when measuring the energy of the state
- Time: The time elapsed since the beginning of the simulation
- Potential Energy range: Range of the potential energy in the simulation region
- Length: Length of the simulated region
- Mass: Mass of the particle being simulated

All units are given in Hartree atomic units. So length is given in terms
of the Bohr radius. Mass is given in terms of the electron mass. Energy
is given in terms of the Hartree energy, which is approximately twice the
ionization energy of the ground state of atomic hydrogen. Time is given
in terms of Planks reduced constant divided by the Hartree energy.
