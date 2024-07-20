#!/bin/bash

# Initialize an empty array
names=()

# Read each line from PRODWintelhosts.txt into an array called names
while IFS= read -r line; do
    names+=("$line")
done < PRODWintelhosts.txt

# Loop through each name in the names array
for name in "${names[@]}"; do
  # Ping the server with a timeout of 1 second and only 1 ping attempt
  if ping -c 1 -W 1 "$name" &> /dev/null; then
    echo "$name,up"
  else
    echo "$name,down"
  fi
done