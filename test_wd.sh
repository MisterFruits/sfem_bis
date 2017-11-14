#!/bin/bash
#SBATCH -J sfem
#SBATCH -N 1
#SBATCH -n 24
#SBATCH -C quad,cache
#SBATCH -t 01:00:00
#SBATCH -o /home/cameo/pcp/out_test_%j
#SBATCH --workdir ./

env | grep -i slurm

echo $PWD

