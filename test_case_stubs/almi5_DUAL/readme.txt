This test case is for reference only. It cannot be run.
You can check how a basic tDCS test case is configured
in OpenFOAM.
Important directories are:
- '0_orig' directory which contains the initial boundary
  conditions for all relevant fields
- 'system' directory which contains the
    a) residual controls (fvSolution)
    b) choice of discretization schemes (fvSchemes)
    c) Definition of the internal, initial conductivity
       field for all mesh compartments (setFields)
    d) settings for the TDCSSolver application
       (solverProperties)

In general a test case will be executed running the
following command:

# (1) Import mesh
gmshToFoam /path/to/mesh_file.msh  

# (2) Adapt scaling              
transformPoints -scale '(0.001 0.001 0.001)'

# (3) Set initial conditions
cp -r 0_orig 0
setFields

# (4) Run the solver application
TDCSSolver

# (5) Visualize results in ParaView
paraFoam