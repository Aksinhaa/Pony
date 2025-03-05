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

### To convert .sra files into fastq files in batches of 25 ###
#!/bin/bash

# Path to SRA Toolkit binaries
SRA_TOOLS="/shared5/Alex/ancient_genomes/sratoolkit.3.2.0-centos_linux64/bin"

# Path where .sra files are stored
SRA_DIR="/shared5/Alex/ancient_genomes"

# Output directory for FASTQ files
OUTPUT_DIR="$SRA_DIR/fastq_files"

# Create output directory if it doesn’t exist
mkdir -p "$OUTPUT_DIR"

# Ensure SRA Toolkit binaries are in PATH
export PATH="$SRA_TOOLS:$PATH"

# Find all .sra files in the directory and store them in an array
mapfile -t SRA_FILES < <(find "$SRA_DIR" -maxdepth 1 -type f -name "*.sra" | sort)

# Total number of files
TOTAL_FILES=${#SRA_FILES[@]}

# Batch size (number of files per batch)
BATCH_SIZE=25

# Process files in batches of 25
for ((i = 0; i < TOTAL_FILES; i += BATCH_SIZE)); do
    echo "Processing batch: $((i + 1)) to $((i + BATCH_SIZE))"

    # Extract the current batch
    BATCH_FILES=("${SRA_FILES[@]:i:BATCH_SIZE}")

    # Loop through each .sra file in the batch
    for sra_file in "${BATCH_FILES[@]}"; do
        base_name=$(basename "$sra_file" .sra)

        echo "Converting $sra_file to FASTQ..."
        
        # Convert SRA to FASTQ (split paired reads, compress output)
        "$SRA_TOOLS/fasterq-dump" --split-3 --outdir "$OUTPUT_DIR" "$sra_file" && gzip "$OUTPUT_DIR/$base_name"*.fastq

        echo "Converted: $sra_file -> $OUTPUT_DIR/$base_name.fastq.gz"
    done

    echo "Batch $((i / BATCH_SIZE + 1)) completed."
done

echo "All .sra files have been converted and saved in: $OUTPUT_DIR"



