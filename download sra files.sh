
###  Downloading SRA Run IDs to server  Using SRA Toolkit

Once you have updated your Excel sheet with the relevant SRA Run IDs (e.g., `ERR...` or `SRR...`), the next step is to download and convert these `.sra` files into FASTQ format for downstream processing. To upload all the SRA files to the server, following command will work: 


#!/bin/bash

# Make sure sratoolkit is in your PATH or load the module if needed
# export PATH="/path/to/sratoolkit:$PATH"  # Uncomment and edit if needed

# List of SRA run IDs (space-separated)
for file in ERR6465214 ERR6465215 ERR6465216
do
    echo " Downloading $file using prefetch..."
    prefetch "$file"
done

echo " All SRA files have been downloaded."


## After using prefetch each run is stored in its own sub‑folder (one directory per SRA ID).
## For downstream processing it is convenient to collect all .sra files into a single directory.
## The script below moves every .sra hidden inside nested sub‑directories up into the chosen parent directory, while keeping a time‑stamped log of what was moved.

#!/bin/bash

# Define the parent directory
PARENT_DIR="define path of your parent directory"
LOG_FILE="$PARENT_DIR/move_sra_log.txt"

# Start logging
echo "$(date) - Starting to move .sra files" > "$LOG_FILE"

# Find and move all .sra files from subdirectories to the parent directory
find "$PARENT_DIR" -mindepth 2 -type f -name "*.sra" | while read -r file; do
    filename=$(basename "$file")
    
    if mv "$file" "$PARENT_DIR/"; then
        echo "$(date) - Moved: $file -> $PARENT_DIR/$filename" >> "$LOG_FILE"
    else
        echo "$(date) - ERROR moving: $file" >> "$LOG_FILE"
    fi
done

echo "$(date) - Completed moving .sra files" >> "$LOG_FILE"

or 

#!/bin/bash
#
# move_sra_to_parent.sh
# Move all *.sra files found two or more levels down
# into the parent directory and record every move.

# 1️⃣  EDIT this to your top‑level folder that contains the prefetch output
PARENT_DIR="/path/to/your/parent_directory"     # e.g. /shared5/Alex/ancient_genomes
LOG_FILE="$PARENT_DIR/move_sra_log.txt"

echo "$(date)  –  Starting to relocate .sra files" > "$LOG_FILE"

# 2️⃣  Find every *.sra file at depth ≥2 and move it one level up (to $PARENT_DIR)
find "$PARENT_DIR" -mindepth 2 -type f -name '*.sra' | while read -r file; do
    filename=$(basename "$file")
    if mv "$file" "$PARENT_DIR/"; then
        echo "$(date)  –  Moved: $file  ➜  $PARENT_DIR/$filename" >> "$LOG_FILE"
    else
        echo "$(date)  –  ERROR moving: $file" >> "$LOG_FILE"
    fi
done

echo "$(date)  –  Completed relocating .sra files" >> "$LOG_FILE"
echo "✅  All .sra files are now in:  $PARENT_DIR"
echo "📄  Detailed log written to:   $LOG_FILE"



## After all .sra files have been moved to the parent directory, the individual subdirectories become empty and are no longer needed. To clean up and free up space, you can safely delete all empty directories using the command below:

#!/bin/bash

# Define the parent directory
PARENT_DIR="define path of your parent directory"

# Delete empty subdirectories
find "$PARENT_DIR" -type d -empty -delete

echo "All empty subdirectories in $PARENT_DIR have been deleted."


