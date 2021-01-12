#!/usr/bin/env bash

mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolic.i mu=0.0
mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolic.i mu=1e-8
mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolic.i mu=1e-7
mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolic.i mu=1e-6
mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolic.i mu=1e-5

mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolicBC.i mu=0.0
mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolicBC.i mu=1e-8
mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolicBC.i mu=1e-7
mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolicBC.i mu=1e-6
mpirun -n 16 ~/MOOSE/raccoon/raccoon-opt -i pseudoparabolicBC.i mu=1e-5
