#!/usr/bin/python3

# Python script to list all the templates, their projects and execution environments in Ansible Automation Platform

import requests
import json
import os

# Disable SSL warnings # Not recommended for production
requests.packages.urllib3.disable_warnings()

# Set the URL for the Ansible Automation Platform
base_url = os.environ.get("AWX_URL")
url = base_url + "api/v2/job_templates/"

# Set the token for the Ansible Automation Platform
token = os.environ.get("TOKEN")

# Set the headers for the Ansible Automation Platform
headers = {
    "Authorization": token,
    "Content-Type": "application/json"
}

# Function to get all templates with pagination
def get_all_templates(url):
    templates = []
    while url:
        response = requests.get(url, headers=headers, verify=False)
        if response.status_code == 200:
            data = response.json()
            templates.extend(data["results"])
            url = base_url + data["next"] if data["next"] else None
            # url = None
        else:
            print("Error: Unable to list templates")
            print(response.text)
            break
    return templates

# Get all templates
templates = get_all_templates(url)

# Loop through the templates and print their names
print ("Name,Project,Execution Environment")
for template in templates:
    project_name = template['summary_fields']['project']['name'] if "project" in template['summary_fields'] and template['summary_fields']["project"] else "N/A"
    if template["execution_environment"] != None:
        execution_environment_url = base_url + f"api/v2/execution_environments/{template['execution_environment']}/"
        # print(execution_environment_url)
        response = requests.get(execution_environment_url, headers=headers, verify=False)
        if response.status_code == 200:
            execution_environment_data = response.json()
            #print (execution_environment_data)
            execution_environment = execution_environment_data["name"]
        else:
            # print("Error: Unable to get execution environment")
            # print(response.text)
            execution_environment = template['execution_environment']
    else:
        execution_environment = "N/A"

    print(f"{template['name']},{project_name},{execution_environment}")

# End of script