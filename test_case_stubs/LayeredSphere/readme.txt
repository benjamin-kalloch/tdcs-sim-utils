You may use the boundary conditions in "0_DIRECHLETBC" if you generate the layered sphere geometry
using GMSH and the Geo-file we provide. Otherwise you must define your own values for ElPot on the
outer surface of the sphere as describe in the main manuscript.

Create the geometry using the Geo-file: layered_sphere_model.geo
To create a tetrahedral mesh with GMSH issue the commmand: gmsh -3 -optimize_threshold 0.5 gmsh_layered_sphere_model.geo.

ElPotOpenFOAM_isolines.png show an exemplary result of this test-case.