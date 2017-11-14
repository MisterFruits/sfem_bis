#!/bin/bash 
#SBATCH -J sfem
#SBATCH -N 1
#SBATCH -n 24
#SBATCH -C quad,cache
#SBATCH -t 01:00:00
#SBATCH -o /home/cameo/pcp/out_sfem_%j

set -x 
set -e

module load intel/18.0
module load intelmpi/2018.0.128

export VEC=xMIC-AVX512
#export VEC=xCORE-AVX2
export my_FC=mpiifort #gfortran
export FCFLAGS_f90="-${VEC}"
export MPIFC=mpiifort
export FCFLAGS="-qopenmp -${VEC} -DUSE_OPENMP -DUSE_FP32 -DOPT_STREAMS -align array64byte -fp-model fast=2 -mcmodel=large"
export DEF_FFLAGS="-qopenmp -${VEC} -DUSE_OPENMP -DUSE_FP32 -DOPT_STREAMS -align array64byte -fp-model fast=2 -mcmodel=large"
export CFLAGS="-O3 -${VEC}"
export FLAGS_CONFIGURE=" --enable-vectorization"
export OPTION_OPTIM=-${VEC}
export OPTION_OMP=-qopenmp
export OPTION_O3=-O3
export MPICC=mpiicc
export MPIF90=mpiifort
export MPICCC=mpiicpc
export MPIICPC=mpiicpc
export MPICXX=mpiicpc
export F90=mpiifort
export FC=mpiifort
export CC=icc
export CXX=icpc
export I_MPI_CC=icc
export I_MPI_CXX=icpc
export I_MPI_F77=ifort
export I_MPI_F90=ifort
#export I_MPI_PROCESS_MANAGER=mpd
#export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so
#export I_MPI_PIN=1
#export I_MPI_STATS=all
#export IPM_LOG=full

if [ "$1" = "clean" ]
then
    rm -rf specfem3d_globe/
    tar -xf /opt/software/tarballs/specfem3d_globe_df5511e7fc1eade655a15b6c8f883cb1c87a5520.tar
    cd specfem3d_globe/
    ./configure $FLAGS_CONFIGURE 
    cd EXAMPLES/small_benchmark_run_to_test_very_simple_Earth
    sed -i 's/-np/-n/g' run_mesher_solver.bash
    bash -x ./run_this_example.sh
else
    cd specfem3d_globe/EXAMPLES/small_benchmark_run_to_test_very_simple_Earth
    bash -x ./run_mesher_solver.bash
fi



