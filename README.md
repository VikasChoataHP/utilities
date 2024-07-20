# Utilities

This repository contains a collection of sample utility scripts for various tasks, including Kubernetes namespace annotation updates, server availability checks, and more. These scripts are designed to provide practical examples and can be adapted for different environments and requirements.

## Repository Contents

- **Bash Scripts**
  - `ping_test.sh`: Script to check the availability of servers listed in a file by pinging them.
  - `k8s/`
    - `update_annotation.sh`: Updates Kubernetes namespace annotations for incident and vulnerability notification groups.
    - `check_annotations.sh`: Checks for namespaces missing specific annotations and lists them.
    - `delete_groups.sh`: Deletes Kubernetes groups listed in a file.

## Getting Started

To use these scripts, clone the repository to your local machine or server where you have the necessary permissions and dependencies installed.

```bash
git clone https://github.com/VikasChoataHP/utilities.git
cd utilities