#!/bin/bash

# Define the base directory (you might want to change this)
BASE_DIR="$HOME"

# Define the folder structure based on your provided structure
FOLDERS=(
  "$BASE_DIR/Archives"
  "$BASE_DIR/Books"
  "$BASE_DIR/Code/Archives"
  "$BASE_DIR/Code/Personal"
  "$BASE_DIR/Personal/_Temp_Hold"
  "$BASE_DIR/Personal/Career"
  "$BASE_DIR/Personal/Education"
  "$BASE_DIR/Personal/Finances"
  "$BASE_DIR/Personal/Health"
  "$BASE_DIR/Personal/Hobbies"
  "$BASE_DIR/Personal/ID"
  "$BASE_DIR/Personal/Personal Media"
  "$BASE_DIR/Personal/Pictures"
  "$BASE_DIR/Work/HR"
  "$BASE_DIR/Work/Pictures"
  "$BASE_DIR/Work/Presentations"
  "$BASE_DIR/Work/work-notes"
)

# Create the folders
echo "Creating base folders..."
for folder in "${FOLDERS[@]}"; do
  mkdir -p "$folder"
  if [ $? -eq 0 ]; then
    echo "Created: $folder"
  else
    echo "Error creating: $folder"
  fi
done

echo "Base folder structure created."
