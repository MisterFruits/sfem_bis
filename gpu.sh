#!/bin/bash 
#SBATCH -J sfem
#SBATCH -N 2
#SBATCH -n 24
#SBATCH --ntasks-per-node=12
#SBATCH -t 01:00:00
#SBATCH -p prace
#SBATCH --gres=gpu:4
#SBATCH -x davide7 # This node had incorrect cuda version so left out

set -x 
set -e

module load pgi cuda-8 openmpi-1.10.2-pgi

export FC=`which pgfortran`
export MPIFC=`which mpif90`
export OMPI_FC=$FC
export CC=`which pgcc`                            
export CPP="pgcc -E"
export OMPI_CC=$CC
export MPICC=`which mpicc`

GCC_OPTS="-fast -Minfo=all -g -mp"
GFORTRAN_OPTS="-Mpreprocess"
export CFLAGS="$GCC_OPTS"  
export FFLAGS="$GCC_OPTS $GFORTRAN_OPTS"   
export CUDA_LIB="/opt/pgi/linuxpower/2016/cuda/8.0/lib64"
export FLAGS_CONFIGURE="--build=ppc64 --with-cuda=cuda8"


echo "TEST12=$TEST12"

if [ "$1" = "clean" ]
then
    rm -rf specfem3d_globe/
    tar -xf ~/specfem3d_globe_df5511e7fc1eade655a15b6c8f883cb1c87a5520.tar
    cd specfem3d_globe/
    ./configure $FLAGS_CONFIGURE 
    cp -R $SLURM_SUBMIT_DIR/testcase1 EXAMPLES/
    cd EXAMPLES/testcase1
    sed -i 's/-np/-n/g' run_mesher_solver.bash
    bash -x ./run_this_example.sh
else
    cd specfem3d_globe/EXAMPLES/testcase1
    bash -x ./run_mesher_solver.bash
fi



