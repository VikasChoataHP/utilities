# Bash script to update annotations in a Kubernetes namespace

#!/bin/bash

# Print current context

echo "Current context: $(kubectl config current-context)"

# Find all the namespace in the cluster where annotation "com.myorg/snowincidentnotificationgroup" is not set or doesn't exists
# Also filter out the system namespaces and default namespaces from the list

for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
  # if namespace name doesn't end with -ns then ignore it
    if [[ $ns != *"-ns" ]]; then
        continue
    fi
  # Fetching the annotation value directly
  echo "Namespace: $ns"
  annotation_value=$(kubectl get ns $ns -o jsonpath='{.metadata.annotations.com\.myorg/snowincidentnotificationgroup}')
  if [[ -z "$annotation_value" ]]; then # Checking if the variable is empty
    echo "Namespace $ns doesn't have annotation com.myorg/snowincidentnotificationgroup"
    #kubectl annotate ns $ns com.myorg/snowincidentnotificationgroup=SLF-OPS-DEV

  fi
done