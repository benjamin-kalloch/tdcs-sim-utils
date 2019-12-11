#!/bin/bash

#
# This script prepares and runs the layered-sphere test case.
#
# Parameters:
#   1) The path to the GMSH msh-file.
#
# Note: The boundary condition defined in 0_DIRICHELTBC will only
#       apply if the mesh was created using an edge-length of 0.00629961
#       in the geo file! Otherwise you will have to create the faceSets
#       representing the electrodes yourself and assign an electrical
#       potential to them.
#

gmshToFoam $1
cp -r 0_DIRECHELTBC 0
setFields
TDCSSolver