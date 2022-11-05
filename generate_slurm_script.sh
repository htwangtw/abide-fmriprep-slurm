#!/bin/bash

CONTAINER_PATH="/lustre03/project/6003287/containers"
VERSION="20.2.1"
EMAIL=${SLACK_EMAIL_BOT}
DATASET_PATH="/lustre04/scratch/hwang1/abide/RawDataBIDS"
OUTPUT_PATH="/lustre04/scratch/hwang1/abide1_fmriprep-${VERSION}lts"
SITES=`ls $DATASET_PATH/`

echo "Create fmriprep-slurm scripts"

module load singularity/3.8

PREPROCESSED_PATH=/lustre04/scratch/hwang1/abide1_fmriprep-${VERSION}lts/
mkdir -p 

for site in ${SITES}; do
    # run BIDS validator on the dataset
    # you only need this done once
    singularity exec -B ${DATASET_PATH}/${site}:/DATA \
        ${CONTAINER_PATH}/fmriprep-20.2.1lts.sif bids-validator /DATA

    fmriprep_slurm_singularity_run.bash \
        ${DATASET_PATH}/${site} \
        ${OUTPUT_PATH} \
        fmriprep-${VERSION}lts \
        --fmriprep-args=\"--use-aroma\" \
        --email=${EMAIL} \
        --time=24:00:00 \
        --mem-per-cpu=12288 \
        --cpus=1 \
        --container fmriprep-${VERSION}lts
done
