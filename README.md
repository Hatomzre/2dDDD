# 2D Discrete Dislocation Dynamics
## About This Project
This project is written in Matlab and used to solve two dimensional dislocation dynamics(2D DD) using FRCG method, BPG method and RKF method. It can deal with 2D
dicrete dislocation dynamics under periodical boundary conditions. For more
information, please check the documentation.
## Code Structure
- input
  >In 'input' folder, there are many files named 'ddTest*.m', which contains
  essential data for solving 2D DD, such as positions of dislocations, Burgers
  vectors of dislocations and so on. Before simulating, you need use these files
  to initial the dislocation systems and calculating parameters.
- dddMain.m
  >This is the main function, you strat to simulate running this files.
- CalcuBy*.m
  >There are three files called as this, which are 'CalcuByFRCG.m',
  'CalcuByBPG.m' and 'CalcuByRKF.m', respectively. You can use different files
  to simulate dislocation dynamics by different methods. For example, if you
  want to solve problems by FRCG method, you would like to use 'CalcuByFRCG.m'.
  You can designate the method you want to use by this way in initial file
  'ddTest*.m'.
- adjustByPBC.m
  >This function change positions of dislocations to meet the periodical boundary
  conditions.
- CalcuStress.m
  >This function calculates the applied stress for systems. When the mean
  velocity of dislocations is below the threshold you set, the applied stress
  will increase according to the rate of stress which is given in input files.
- CalcuStrain.m
  >This function calculates the strain of systems.
- force*.m
  >This function depends on the periodical boundary conditions you choose. If
  there is infinite in both X and Y directions, this file will be 'forceInf.m'.
  If there is infinite in Y direction but periodical in X direction, this file
  will be 'forceXPBC.m'. If there is periodical in both X and Y directions, this
  file will be 'forceCut.m'.
- energy*.m
  >This function depends on the periodical boundary conditions you choose. If
  there is infinite in both X and Y directions, this file will be 'energyInf.m'.
  If there is infinite in Y direction but periodical in X direction, this file
  will be 'energyXPBC.m'. If there is periodical in both X and Y directions, this
  file will be 'energyCut.m'.
- initialSystem.m
  >This function will create a system of dislocations using the number given. It
  generate positions and Burgers vectors of dislocations randomly. Using this
  function, you can have a system of dislocations and then write all data into
  input files, 'ddTest*.m'.
- drndt.m
  >This function calculates the velocity for each dislocation.
- plotDislocation.m
  >This function can give a plot of systems of dislocations. If you want to know
  where dislocations are, you can use it to get a figure.
- mobility.m
  >This function is used to apply the damping coefficient.
- fixPos.m
  >This function fixes dislocations which are too close. Because those close
  dislocations difinitely have a huge impact on simulating in the aspects of
  accuracy and speed, this function make them fixed to improve the speed of
  calculating.
