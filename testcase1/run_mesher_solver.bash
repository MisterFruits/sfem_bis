#!/bin/bash

###########################################################

## CPUs
CPUs=24

###########################################################

BASEMPIDIR=`grep LOCAL_PATH DATA/Par_file | cut -d = -f 2 `

# script to run the mesher and the solver
# read DATA/Par_file to get information about the run
# compute total number of nodes needed
NPROC_XI=`grep NPROC_XI DATA/Par_file | cut -d = -f 2 `
NPROC_ETA=`grep NPROC_ETA DATA/Par_file | cut -d = -f 2`
NCHUNKS=`grep NCHUNKS DATA/Par_file | cut -d = -f 2 `

# total number of nodes is the product of the values read
numnodes=$(( $NCHUNKS * $NPROC_XI * $NPROC_ETA ))

if [ ! "$numnodes" == "$CPUs" ]; then
  echo "error: Par_file for $numnodes CPUs"
  exit 1
fi

mkdir -p OUTPUT_FILES

# backup files used for this simulation
cp DATA/Par_file OUTPUT_FILES/
cp DATA/STATIONS OUTPUT_FILES/
cp DATA/CMTSOLUTION OUTPUT_FILES/


export I_MPI_DOMAIN=auto
export I_MPI_PIN_RESPECT_CPUSET=0
export OMP_NUM_THREADS=11
export KMP_AFFINITY=scatter

export KMP_BLOCKTIME=infinite
export KMP_LIBRARY=turnaround

./ExpandNodeList -r -p $SLURM_NTASKS_PER_NODE $SLURM_NODELIST > mf


##
## mesh generation
##
sleep 2

echo
echo `date`
echo "starting MPI mesher on $numnodes processors"
echo

mpirun -machinefile mf -n $numnodes $PWD/bin/xmeshfem3D

echo "  mesher done: `date`"
echo

# backup important files addressing.txt and list*.txt
cp OUTPUT_FILES/*.txt $BASEMPIDIR/


##
## forward simulation
##

sleep 2

echo
echo `date`
echo starting run in current directory $PWD
echo

mpirun -machinefile mf -n $numnodes $PWD/bin/xspecfem3D

echo "finished successfully"
echo `date`

