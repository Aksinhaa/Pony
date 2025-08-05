## To convert the .sra files into .fastq, for the dowstream ananlysis we need to install SRA toolkit.
# Step 1: Create a separate env:

conda create -n sra_env 
conda activate sra_env

# Step 2: Install SRA toolkit in that env: 

conda install -c bioconda sra-tools

### Step 3: Convert .sra files into fastq files  ###

Step 1: Save your filenames in a file using cat or nano. Name the file in any manner, here the file name is "sra_to_convert.txt". You can list all your file names like below:


cat > sra_to_convert.txt <<EOF
SRRXXX.sra
SRRXXX.sra
SRRXXX.sra
SRRXXX.sra
SRRXXX.sra
EOF

 Step 2: Run fasterq-dump for each file
Assuming all .sra files are in "sra_to_convert.txt" , run this loop:

while read sra; do
    fasterq-dump --split-files -p -e 8 \
    -O /"Give output directory path"/ \
    /"Give input directory path"/"$sra"
done < sra_to_convert.txt



OR 


## Convert your .sra files in batches of 25: {In case if you have huge number of files}

#!/bin/bash

# Path to SRA Toolkit binaries
SRA_TOOLS="PATH"

# Path where .sra files are stored
SRA_DIR="PATH"

# Output directory for FASTQ files
OUTPUT_DIR="PATH"

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
