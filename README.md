launch on frioul:

''' shell
sbatch -C quad,cache --ntasks-per-node=6 -N4 -c 11 -t 1:00:00 -D $SCRATCHDIR my_sfem.sh  clean
'''

launch on pcp:

''' shell
sbatch --ntasks-per-node=6 -N4 -c 11 -t 1:00:00 -D $SCRATCHDIR my_sfem.sh  clean
'''
