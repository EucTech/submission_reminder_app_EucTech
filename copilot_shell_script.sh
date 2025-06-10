#!/bin/bash

read -p "Enter the new Assignment Name: " assignment_name

# Check if config.env exists inside any config directory in the current directory (or subdirs)
config_path=$(find . -type f -path "*/config/config.env" | head -n 1)

if [ -z "$config_path" ]; then
  echo "Error: config.env not found."
  exit 1
fi

# Use sed to replace ASSIGNMENT in the found config.env file
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$assignment_name\"/" "$config_path"

echo "Updated ASSIGNMENT in $config_path to \"$assignment_name\""
