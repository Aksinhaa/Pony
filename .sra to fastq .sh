
###  Converting SRA Run IDs to FASTQ Files Using SRA Toolkit

Once you have updated your Excel sheet with the relevant SRA Run IDs (e.g., `ERR...` or `SRR...`), the next step is to download and convert these `.sra` files into FASTQ format for downstream processing.

We use the **SRA Toolkit**, specifically the `fasterq-dump` utility, which is optimized for speed and supports splitting paired-end reads. These FASTQ files serve as the raw sequencing input for quality control, trimming, alignment, and all subsequent analyses.

Make sure your SRA Toolkit is installed and accessible in your system’s `PATH`, and then proceed to download and convert your `.sra` files in batch mode.

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



