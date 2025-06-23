
##  BAM Quality Control with **Qualimap**

Once your BAM files have been generated and aligned, it's crucial to assess their quality using tools like **Qualimap**, which provides detailed statistics and plots to evaluate alignment, coverage, GC bias, and more.

## Below is a step-by-step script to run `qualimap bamqc` on a BAM file from an ancient DNA pipeline.
## First make an individual conda environment to install qualimap 

conda create -n qualimap 
conda activate qualimap

conda install bioconda::qualimap

###  Script to run qualimap for individual BAM file

```
# Path to the input BAM file
bam="/shared5/Alex/ancient_genomes/bam_pipeline/ERR6465277.GCF_002863925.1_EquCab3.0_genomic.bam"

# Extract the filename without the ".bam" extension
full=$(basename "$bam" .bam)

# Extract the sample prefix before the first dot in the filename
prefix=${full%%.*}

# Run Qualimap's BAMQC module
qualimap bamqc \
  -bam "$bam" \
  -outdir "/shared5/Alex/ancient_genomes/qualimap_results/bamqc_${prefix}" \
  -outformat PDF \
  -nt 4
```



###  Explanation of Each Step

#### `bam="/path/to/your.bam"`

This sets the full path to the input **BAM file** — the binary format of your aligned sequencing reads. This is the input for `qualimap bamqc`.

#### `full=$(basename "$bam" .bam)`

Extracts the base filename (without `.bam` extension). For example:

* If `$bam` is `ERR6465277.GCF_002863925.1_EquCab3.0_genomic.bam`
* Then `$full` becomes `ERR6465277.GCF_002863925.1_EquCab3.0_genomic`

#### `prefix=${full%%.*}`

Extracts the **prefix or sample ID**, usually the first part of the filename before the first dot. In this case:

* `$prefix` becomes `ERR6465277`

This prefix is used to label the output directory uniquely per sample.


###  Running Qualimap

#### `qualimap bamqc`

Runs the **BAM Quality Control** module of Qualimap.

##### Parameters:

* `-bam "$bam"` — The input BAM file.
* `-outdir` — Output directory for the QC reports (created automatically if it doesn't exist).
* `-outformat PDF` — Generates a user-friendly PDF report.
* `-nt 4` — Uses 4 threads for faster execution.



###  Output

Inside output directory, you'll find:

* `qualimapReport.pdf` — Main visual report with graphs and stats
* `genome_results.txt` — Plain text summary of alignment metrics
* `raw_data/` — Intermediate files and detailed metrics



OR

## Script to automate the qualimap step for multiple BAM files: 

#!/bin/bash

# Set input and output directories
BAM_DIR="/shared5/Alex/ancient_genomes/bam_pipeline"
OUT_DIR="/shared5/Alex/ancient_genomes/qualimap_results"

# Create output directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Loop through each .bam file in the input directory
for bam in "$BAM_DIR"/*.bam; do
    # Extract filename without the .bam extension
    full=$(basename "$bam" .bam)

    # Extract sample prefix before the first dot
    prefix=${full%%.*}

    # Define output path for this sample
    sample_out="$OUT_DIR/bamqc_${prefix}"

    # Check if output folder already exists
    if [ -d "$sample_out" ]; then
        echo " Skipping $prefix — already processed."
        continue
    fi

    echo " Processing $prefix..."

    # Run Qualimap bamqc
    qualimap bamqc \
      -bam "$bam" \
      -outdir "$sample_out" \
      -outformat PDF \
      -nt 4

    echo "✅ Finished processing $prefix"
done
