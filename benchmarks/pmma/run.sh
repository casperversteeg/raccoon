#!/usr/bin/env bash

gmsh mesh/dynamic_pmma_geom.geo -2 -o mesh/dynamic_pmma_geom.msh
mpirun -n 16 ../../raccoon-opt -i pmma_static_initialization.i BCs/top_BC/value='0.06'
# mpirun -n 16 ../../raccoon-opt -i vanilla/mechanical.i BCs/top_BC/value='0.06'
# mpirun -n 16 ../../raccoon-opt -i hyperbolic/mechanical.i BCs/top_BC/value='0.06'
# mpirun -n 16 ../../raccoon-opt -i mechanical.i BCs/top_BC/value='0.10'
# mpirun -n 16 ../../raccoon-opt -i hyperbolic_pmma.i BCs/top_BC/value='0.06'
mpirun -n 16 ../../raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.06' mu=0
mpirun -n 16 ../../raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.06' mu=9e-9
mpirun -n 16 ../../raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.06' mu=9e-8
mpirun -n 16 ../../raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.06' mu=9e-7
mpirun -n 16 ../../raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.06' mu=9e-6

# For Sodalime problem, see whether we can model the putty boundary layer
