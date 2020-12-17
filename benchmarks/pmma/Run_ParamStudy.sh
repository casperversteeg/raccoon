#/bin/bash
#SBATCH -N 1
#SBATCH --ntasks=35
#SBATCH --job-name=viscous
#SBATCH --partition=dolbowlab
#SBATCH --mem-per-cpu=10G

export SLURM_CPU_BIND=none

echo "Start: $(date)"
echo "cwd: $(pwd)"

mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i pmma_static_initialization.i BCs/top_BC/value='0.1'
mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.1' mu=0
mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.1' mu=1e-12
mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.1' mu=1e-11
mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.1' mu=1e-10
mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.1' mu=5e-9
mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.1' mu=1e-9
mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.1' mu=5e-8
mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.1' mu=1e-8
mpirun ~/cv83/rickashley/raccoon/raccoon-opt -i viscous/mechanical.i BCs/top_BC/value='0.1' mu=5e-7

echo "End: $(date)"
