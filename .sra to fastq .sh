
###  Converting SRA Run IDs to FASTQ Files Using SRA Toolkit

Once you've updated your Excel sheet with the relevant SRA Run IDs (e.g., `ERR...` or `SRR...`), the next step is to download and convert these `.sra` files into FASTQ format for downstream processing.

We use the **SRA Toolkit**, specifically the `fasterq-dump` utility, which is optimized for speed and supports splitting paired-end reads. These FASTQ files serve as the raw sequencing input for quality control, trimming, alignment, and all subsequent analyses.

Make sure your SRA Toolkit is installed and accessible in your system’s `PATH`, and then proceed to download and convert your `.sra` files in batch mode.


