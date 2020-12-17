#!/usr/bin/env bash

mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i 1D.i mu=0.0
# mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i 1D.i mu=1e-3
# mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i 1D.i mu=1e-2
# mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i 1D.i mu=1e-1
# mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i 1D.i mu=1e-0
