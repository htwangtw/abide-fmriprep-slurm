# abide-fmriprep-slurm

Create SLURM scripts for preprocessing ABIDE 1 and 2 wih fMRIPrep.
The process was done on Compute Canada Beluga.

## Dependency

- datalad
- [fmriprep-slurm](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)

## Retrieving data

A BIDS competable version of the ABIDE dataset are avalible through [datalad repository](http://datasets.datalad.org/)

## Generating slurm jobs with fMRIPrep slurm

1. Set up your environment following [this tutorial](https://simexp-documentation.readthedocs.io/en/latest/giga_preprocessing/preprocessing.html)

2. Run `./generate_slurm_script.sh`. It will call `fmriprep_slurm_singularity_run.sh`; which is a modified version of `singularity_run.bash` from `fmriprep-slurm`.

    You need: root of output directory, path to bids dataset, output derivative directory name.

    A minimal use case of this version:
    ```
    bash ./fmriprep_slurm_singularity_run.bash \
            ${OUTPUT_ROOT_PATH} \
            ${BIDS_DATASET_PATH} \
            derivatives
    ```

3. To submit jobs for each dataset, the command to use will be similar to this.
    ```
    find "$OUTPUT_DIR"/.slurm/smriprep_sub-*.sh -type f | while read file; do sbatch "$file"; done
    ```
    
4. Archive the dataset. [See this page](https://simexp-documentation.readthedocs.io/en/latest/alliance_canada/tape.html)

    Run the process on a computing node in a tmux session.
    ```
    tmux
    salloc --account=rrg-pbellec --mem-per-cpu=8G --time=8:00:0 --cpus-per-task=1
    ```
    After starting the session, archive the data:
    ```
    cd /path/to/fmriprep/derivative
    FILENAME=${PWD##*/} 
    tar -vcf /nearline/ctb-pbellec/giga_preprocessing_2/${FILENAME}.tar.gz .
    ```
    We do not apply the compression (`-z`) flag to save computing time. 
    
    Exit from the tmux session with key combo `ctrl-b-d`

## Timeseries extraction 

TBA
