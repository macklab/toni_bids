#!/bin/bash

# NOTE: change this to the absolute path of the toni_bids directory
bidsdir=**CHANGEME**/toni_bids

# convert dicoms to BIDS format dataset
dcm2bids \
    -d $bidsdir/sourcedata/S2_20171026 \
    -p 101 \
    -c $bidsdir/code/config.json \
    -o $bidsdir

# run MRIQC
docker run -it --rm \
    -v $bidsdir:/data:ro \
    -v $bidsdir/derivatives/mriqc:/out \
    poldracklab/mriqc:latest \
    /data /out participant \
    --participant_label 101 \
    --verbose-reports

# run fmriprep
#  note: A license file has to be provided to run freesurfer.
#        Download from freesurfer website and follow the fmriprep
#        docs to run freesurfer as part of fmriprep.
docker run -it --rm \
    -v $bidsdir:/data:ro \
    -v $bidsdir/derivatives:/out \
    poldracklab/fmriprep:latest \
    /data /out participant \
    --participant_label 101 \
    --ignore slicetiming \
    --fs-no-reconall
