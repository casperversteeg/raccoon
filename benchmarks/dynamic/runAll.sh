#!/usr/bin/env bash
<<<<<<< HEAD
=======

./genMesh.sh
# mpirun -n 16 ../../raccoon-opt -i vanilla/quasistatic.i
# mpirun -n 16 ../../raccoon-opt -i nonvariational/quasistatic.i
# mpirun -n 16 ../../raccoon-opt -i quasistatic.i
# mpirun -n 16 ../../raccoon-opt -i vanilla/dynamic_branching.i
# mpirun -n 16 ../../raccoon-opt -i nonvariational/dynamic_branching.i
# mpirun -n 16 ../../raccoon-opt -i dynamic_branching.i

# mpirun -n 16 ../../raccoon-opt -i vanilla/staggered.i
# mpirun -n 16 ../../raccoon-opt -i nonvariational/staggered.i
<<<<<<< HEAD
mpirun -n 16 ../../raccoon-opt -i staggered.i
>>>>>>> stagger swagger matters naught
=======
mpirun -n 16 ../../raccoon-opt -i nonvariational/staggered.i d_tlower=0.1 d_tupper=0.9
# mpirun -n 16 ../../raccoon-opt -i staggered.i
>>>>>>> release rate mumbo jumbo
