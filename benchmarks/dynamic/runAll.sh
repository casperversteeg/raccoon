#!/usr/bin/env bash

# ./genMesh.sh
# mpirun -n 16 ../../raccoon-opt -i vanilla/quasistatic.i
# mpirun -n 16 ../../raccoon-opt -i nonvariational/quasistatic.i
# mpirun -n 16 ../../raccoon-opt -i quasistatic.i
# mpirun -n 16 ../../raccoon-opt -i vanilla/dynamic_branching.i
# mpirun -n 16 ../../raccoon-opt -i nonvariational/dynamic_branching.i
# mpirun -n 16 ../../raccoon-opt -i dynamic_branching.i

# mpirun -n 16 ../../raccoon-opt -i vanilla/staggered.i
# mpirun -n 16 ../../raccoon-opt -i nonvariational/staggered.i
mpirun -n 16 ../../raccoon-opt -i staggered.i
