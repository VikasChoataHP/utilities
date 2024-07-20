# Read namespace list from ns.txt file and get annotation "com.myorg/snowincidentnotificationgroup" value
# If annotation doesn't exist, print the namespace name
#!/bin/bash

# Read namespace list from ns.txt file

REMOTE_API_URL="https://support-api.dev-openshift-na.hybrid.myorgcorp.com"
apiUrl="api.dev-openshift-na.hybrid.myorgcorp.com"

# Get token for support API
token=`curl -sS -u $(echo $adminuser | base64 -d):$(echo $adminpassword | base64 -d) ${REMOTE_API_URL}/api/v4/auth/token/issue -H 'accept: application/json' | jq -r '.token' 2>&1`
# Update namespaces with annotation com.myorg/snowincidentnotificationgroup
while read ns; do
  echo "Namespace: $ns"
  annotation_value=$(kubectl get ns $ns -o jsonpath='{.metadata.annotations.com\.myorg/snowincidentnotificationgroup}')
  if [[ -z "$annotation_value" ]]; then
    echo "Namespace $ns doesn't have annotation com.myorg/snowincidentnotificationgroup"
    echo ""
    org_name=$(kubectl get ns $ns -o jsonpath='{.metadata.labels.com\.myorg/organization}')

    cmd=$(curl -sS -X 'GET' ${REMOTE_API_URL}/api/v4/organizations/${apiUrl}/${org_name}/db -H 'accept: application/json' -H "Authorization: Bearer $token")
    
    snowIncidentNotificationGroup=$(echo $cmd | sed 's/.*"snowIncidentNotificationGroup":"\([^"]*\)".*/\1/')
    echo "Namespace $ns orgainzation name is $org_name and snowIncidentNotificationGroup is $snowIncidentNotificationGroup"

    kubectl annotate ns $ns com.myorg/snowincidentnotificationgroup="$snowIncidentNotificationGroup"
  else
    echo "Namespace $ns has annotation com.myorg/snowincidentnotificationgroup=$annotation_value"
    echo ""
  fi

  # Repeat the same for snowvulnerabilitynotificationgroup
    annotation_value_v=$(kubectl get ns $ns -o jsonpath='{.metadata.annotations.com\.myorg/snowvulnerabilitynotificationgroup}')
    if [[ -z "$annotation_value_v" ]]; then
        echo "Namespace $ns doesn't have annotation com.myorg/snowvulnerabilitynotificationgroup"
        echo ""
        org_name=$(kubectl get ns $ns -o jsonpath='{.metadata.labels.com\.myorg/organization}')

        cmd_1=$(curl -sS -X 'GET' ${REMOTE_API_URL}/api/v4/organizations/${apiUrl}/${org_name}/db -H 'accept: application/json' -H "Authorization: Bearer $token")

        # Get snowVulnerabilityNotificationGroup value from cmd_1 without JQ
        snowVulnerabilityNotificationGroup=$(echo $cmd_1 | sed 's/.*"snowVulnerabilityNotificationGroup":"\([^"]*\)".*/\1/')

        echo "Namespace $ns orgainzation name is $org_name and snowVulnerabilityNotificationGroup is $snowVulnerabilityNotificationGroup"

        # Annotate namespace with snowVulnerabilityNotificationGroup value
        kubectl annotate ns $ns com.myorg/snowvulnerabilitynotificationgroup="$snowVulnerabilityNotificationGroup"
    else
        echo "Namespace $ns has annotation com.myorg/snowvulnerabilitynotificationgroup=$annotation_value_v"
        echo ""
    fi

done < ns.txt




