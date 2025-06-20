
# 🐴 Exmoor Pony Ancient DNA Project

> **Ancient genome analysis pipeline** for Exmoor ponies using modern bioinformatics tools to explore evolutionary insights, population history, and genetic diversity from ancient DNA (aDNA) samples.

---

##  Project Structure

```
Exmoor_Pony_Project/
│
├── input_files/           # Raw input data (FASTQ/SRA/BAM)
├── working_files/         # Intermediate and converted files
├── output_files/          # Final analysis outputs
├── scripts/               # Custom and automated scripts
├── configs/               # YAML and Makefiles for PALEOMIX
├── qualimap_results/      # BAMQC reports from Qualimap
├── figures/               # Plots, coverage graphs, etc.
└── README.md              # Project overview and usage guide
```

---

## 🔬 Project Goals

* Process and analyze ancient DNA (aDNA) from Exmoor pony samples.
* Use standardized, reproducible bioinformatics pipelines.
* Perform quality control, read alignment, damage profiling, and coverage analysis.
* Investigate genetic integrity, damage patterns, and evolutionary insights.

---

## 🧰 Tools Used

| Tool               | Purpose                                |
| ------------------ | -------------------------------------- |
| **PALEOMIX**       | End-to-end ancient DNA pipeline        |
| **AdapterRemoval** | Adapter trimming and quality filtering |
| **BWA (aln)**      | Short-read aligner optimized for aDNA  |
| **MapDamage2**     | DNA damage profiling and visualization |
| **Qualimap**       | BAM quality control and metrics        |
| **samtools**       | BAM/SAM manipulation and statistics    |
| **Python, R**      | Custom scripts, plotting, statistics   |

---

## ⚙️ Pipeline Overview

1. **Raw Data Preprocessing**

   * Convert `.sra` to `.fastq` if needed
   * Trim adapters with AdapterRemoval
   * Filter for read quality

2. **Mapping to Reference Genome**

   * Align to *EquCab3.0* using BWA (aln mode)
   * Remove duplicates
   * Index and sort BAM files

3. **Quality Control**

   * Run `qualimap bamqc` for BAM QC metrics
   * Inspect GC bias, insert sizes, coverage

4. **Damage Analysis**

   * Run `mapDamage2` to assess deamination and fragmentation
   * Output plots and summary statistics

5. **Coverage Analysis & Filtering**

   * Use `samtools depth`, `bedtools`, and other tools for genome-wide coverage summaries

---

## 📊 Example: BAM QC with Qualimap

```bash
bam="/shared5/Alex/ancient_genomes/bam_pipeline/ERR6465277.GCF_002863925.1_EquCab3.0_genomic.bam"
full=$(basename "$bam" .bam)
prefix=${full%%.*}

qualimap bamqc \
  -bam "$bam" \
  -outdir "/shared5/Alex/ancient_genomes/qualimap_results/bamqc_${prefix}" \
  -outformat PDF \
  -nt 4
```

---

## 🧬 Example: DNA Damage Profiling with MapDamage2

```bash
# Inside mapDamage source directory and conda env:
python setup.py install

# Example command
mapDamage \
  -i ERR6465277.bam \
  -r GCF_002863925.1_EquCab3.0_genomic.fna \
  -d output_mapdamage_ERR6465277 \
  --no-stats \
  --merge-reference-sequences
```

👉 See [installation script here](https://github.com/PoODL-CES/Ancient_data_Processing/blob/main/MapDamage2%20installation.sh)

---

## 📥 Input Requirements

* **Sequencing data**: `.fastq.gz` or `.sra` (single-end or paired-end)
* **Reference genome**: *EquCab3.0* in FASTA format (indexed)
* **Sample sheet**: For use with PALEOMIX (YAML format)

---

## 📤 Output Summary

* BAM files (sorted, indexed, deduplicated)
* QC reports (`qualimapReport.pdf`, `mapDamage plots`)
* Alignment stats and logs
* Coverage and depth data
* Visualizations (damage patterns, fragment lengths)

---

## 🧪 Sample Commands & Scripts

* See [`scripts/`](./scripts/) for batch processing, conversions, and automated analysis
* See [`configs/`](./configs/) for PALEOMIX Makefile and sample sheet configuration

---

