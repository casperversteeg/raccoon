#!/usr/bin/env bash

gmsh mesh/dynamic_pmma_geom.geo -2 -o mesh/dynamic_pmma_geom.msh
mpirun -n 4 ../../raccoon-opt -i pmma_static_initialization.i BCs/top_BC/value='0.10'
# mpirun -n 16 ../../raccoon-opt -i vanilla/mechanical.i BCs/top_BC/value='0.10'
mpirun -n 4 ../../raccoon-opt -i hyperbolic/mechanical.i BCs/top_BC/value='0.10'
# mpirun -n 16 ../../raccoon-opt -i mechanical.i BCs/top_BC/value='0.10'
