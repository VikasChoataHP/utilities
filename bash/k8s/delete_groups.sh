# Bash script to read group list from file and delete them in k8s
!#/bin/bash

# Read group list from file
while read group; do
  echo "Deleting $group"
  kubectl delete $group
done < groups.txt