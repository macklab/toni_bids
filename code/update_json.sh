#!/bin/bash
## Example script for updating json files with jq and sponge

sbj=$1
sbjdir=sub-${sbj}

# add taskname to functionals
for r in {1..3}
do
    funcpath=${sbjdir}/func/sub-${sbj}_task-learn_run-0${r}_bold.json
    jq '.TaskName="learn"' <${funcpath} | sponge ${funcpath}
done

# add echo times to fieldmaps
fmpath=${sbjdir}/fmap/sub-${sbj}_run-01_phasediff.json
jq '.EchoTime1=0.00492' <${fmpath} | sponge ${fmpath}
jq '.EchoTime2=0.00738' <${fmpath} | sponge ${fmpath}

# add functionals to fieldmaps
fmpath=${sbjdir}/fmap/sub-${sbj}_run-01_phasediff.json
jq '.IntendedFor=[]' <$fmpath | sponge $fmpath
for r in {1..3}
do
    funcpath=func/sub-${sbj}_task-learn_run-0${r}_bold.nii.gz
    jq --arg funcpath "$funcpath" '.IntendedFor += [$funcpath]' <$fmpath | sponge $fmpath
done
