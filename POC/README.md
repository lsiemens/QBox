#POC
Some proof of concept code for solving the particle in a box problem.

##Method
Solving particle in a box using a finite element solver on the shrodinger equation
1.  Use a variable substitution t=i*t' and rearange the shrodinger equation into the form of the heat equation
2.  Represent the potential as a heat sink, and solve the time evolution of the heat equation.
3.  Given the potential was selected such that all energy states are positive, then after some time t the solution of the heat equation will aproche the ground state of the particle in a box problem.
4.  Solve the problem, again this time removing any contribution from the previously found ground state, the solution will then tend towards some state in the first excited state.

After calculating the energy asociated to each of the identified states, then time dependent solutions of the shrodinger equation can be aproximated.

##Conclusion
The proof of concept code sucessfully found steady state solutions to the shrodinger equation
##Goals
- [ ] Accurate solutions to the particle in a box problem.
- [ ] Realtime solutions
