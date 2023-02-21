#!/bin/bash

FMRIPREP_PATH="/lustre04/scratch/hwang1/abide2_fmriprep-20.2.1lts_1667762103"
SITES=`ls $FMRIPREP_PATH`
ATLAS="Schaefer20187Networks MIST DiFuMo"

for site in ${SITES}; do
    for atlas in ${ATLAS}; do
        echo $atlas
        echo $site
        if [ $atlas == "DiFuMo" ]; then
            mem=32G
        else
            mem=8G
        fi
        echo $mem
        sbatch \
            --mem-per-cpu=${mem} --job-name=abide2_connectome_${site}_${atlas} \
            --mail-user=${SLACK_EMAIL_BOT} \
            --export=ATLAS=$atlas,SITE=$site \
             ./connectome_slurm_run.bash
    done
done