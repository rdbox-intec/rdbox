#!/bin/bash

NODE=`hostname`
PARENT_DIR=/mnt/rdbox/.kube

# commons
for file in `find ${PARENT_DIR}/applys/commons -type f -name *.yaml.tmpl 2>/dev/null`; do
    cat $file | sed "s/{{ROS_MASTERNAME}}""/`hostname`/g" | sed "s/{{TB3_MODEL}}""/`HN=\`hostname\` && if [[ $HN =~ ^tb3b ]]; then echo "burger"; elif [[ $HN =~ ^tb3w ]]; then echo "waffle_pi"; else echo "burger"; fi`/g" | kubectl apply -f -
done

# labels
for sub_dir in `kubectl --kubeconfig ${PARENT_DIR}/config get node ${NODE} -o json | jq -r '.metadata.labels | to_entries | .[] | .key + "/" + .value + ""'`; do
    for file in `find ${PARENT_DIR}/applys/${sub_dir} -type f -name *.yaml.tmpl :2>/dev/null`; do
        cat $file | sed "s/{{ROS_MASTERNAME}}""/`hostname`/g" | sed "s/{{TB3_MODEL}}""/`HN=\`hostname\` && if [[ $HN =~ ^tb3b ]]; then echo "burger"; elif [[ $HN =~ ^tb3w ]]; then echo "waffle_pi"; else echo "burger"; fi`/g" | kubectl apply -f -
    done
done
