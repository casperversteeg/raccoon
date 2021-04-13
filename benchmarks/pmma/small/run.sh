#!/usr/bin/env bash

gmsh mesh/geom.geo -2 -o mesh/geom.msh
mpirun -n 16 ../../../raccoon-opt -i pmma_static_initialization.i BCs/top_BC/value='0.12'
# mpirun -n 16 ../../../raccoon-opt -i mechanicalConstant.i BCs/top_BC/value='0.12'
# mpirun -n 16 ../../../raccoon-opt -i mechanicalViscous.i BCs/top_BC/value='0.12'
# mpirun -n 16 ../../../raccoon-opt -i mechanicalViscousMu.i BCs/top_BC/value='0.12'
mpirun -n 16 ../../../raccoon-opt -i mechanicalMu.i BCs/top_BC/value='0.12'
# mpirun -n 16 ../../../raccoon-opt -i mechanicalLinear.i BCs/top_BC/value='0.12'

# For Sodalime problem, see whether we can model the putty boundary layer
