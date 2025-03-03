# Pony
### To take out .sra files from the subdirectories placed in one parent directory in one go ###

#!/bin/bash

# Define the parent directory
PARENT_DIR="define path of your parent directory"
LOG_FILE="$PARENT_DIR/move_sra_log.txt"

# Start logging
echo "$(date) - Starting to move .sra files" > "$LOG_FILE"

# Find and move all .sra files from subdirectories to the parent directory
find "$PARENT_DIR" -mindepth 2 -type f -name "*.sra" | while read -r file; do
    # Extract filename
    filename=$(basename "$file")
    
    # Move file to parent directory
    if mv "$file" "$PARENT_DIR/"; then
        echo "$(date) - Moved: $file -> $PARENT_DIR/$filename" >> "$LOG_FILE"
    else
        echo "$(date) - ERROR moving: $file" >> "$LOG_FILE"
    fi
done

echo "$(date) - Completed moving .sra files" >> "$LOG_FILE"

### To delete all empty subdirectories in one go ###
#!/bin/bash

# Define the parent directory where empty subdirectories should be deleted
PARENT_DIR="define path of your parent directory"

# Find and delete empty subdirectories
find "$PARENT_DIR" -type d -empty -delete

# Print message
echo "All empty subdirectories in $PARENT_DIR have been deleted."

### To make dummy files to ptactice running script ###

mkdir dummyrun
cd dummyrun
mkdir subdir1
touch /home/akancha/dummyrun/subdir1/fake_data.sra(choose file name ac to preferene)

