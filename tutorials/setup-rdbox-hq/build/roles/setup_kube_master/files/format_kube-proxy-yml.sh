#!/bin/bash

#
FILE_IN=-
if [ "$1" != "" ] ; then
    FILE_IN=$1
fi

#
grep -v \
-e creationTimestamp: \
-e generation: \
-e resourceVersion: \
-e selfLink: \
-e uid: \
-e revisionHistoryLimit \
-e status: \
-e currentNumberScheduled: \
-e desiredNumberScheduled: \
-e numberAvailable: \
-e numberMisscheduled: \
-e numberReady: \
-e observedGeneration: \
-e updatedNumberScheduled: \
${FILE_IN}

#
