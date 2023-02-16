#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --job-name=abide2_connectome
#SBATCH --output=/lustre04/scratch/hwang1/logs/abide2_connectome.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/logs/abide2_connectome.%a.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH --array=1-19

ABIDE2_FMRIPREP=/lustre04/scratch/hwang1/abide2_fmriprep-20.2.1lts_1667762103
ABIDE2_CONNECTOME=/lustre04/scratch/hwang1/abide2_connectomes
WORKINGDIR=$ABIDE2_CONNECTOME/working_directory
STRATEGIES="simple simple+gsr scrubbing.5 scrubbing.5+gsr scrubbing.2 scrubbing.2+gsr acompcor50 icaaroma"
ATLAS="Schaefer20187Networks MIST DiFuMo"
SITES=(`ls $ABIDE2_FMRIPREP`)
site=${SITES[${SLURM_ARRAY_TASK_ID} - 1 ]}

mkdir -p $WORKINGDIR

echo ${ABIDE2_FMRIPREP}/${site}/fmriprep-20.2.1lts
if [ -d "${ABIDE2_FMRIPREP}/${site}/fmriprep-20.2.1lts" ]; then
    mkdir $WORKINGDIR/$site
    mkdir $ABIDE2_CONNECTOME/$site
    for strategy in $STRATEGIES; do
	    echo "=========$strategy========="
        for atlas in $ATLAS; do
	    echo "$atlas"
	    giga_connectome \
	    	-w ${WORKINGDIR}/${site} \
	    	--atlas $atlas \
	    	--denoise-strategy ${strategy} \
	    	${ABIDE2_FMRIPREP}/${site}/fmriprep-20.2.1lts \
	    	${ABIDE2_CONNECTOME}/${site} \
	    	group
	done
    done
else
    echo "no preprocessed data for ${site}"
fi

