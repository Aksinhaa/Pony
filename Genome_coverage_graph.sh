

# Command to plot the graph using R-env

conda create -n r_plot_env -c conda-forge r-base r-ggplot2 r-scales
conda activate r_plot_env

# coverage_summary_plot.R

library(tidyverse)

# Set the path to the Qualimap results
results_dir <- "/shared5/Alex/ancient_genomes/qualimap_results"
output_file <- file.path(results_dir, "summary_plots/coverage_plot.png")

# Get all genome_results.txt files
files <- list.files(results_dir, pattern = "genome_results.txt", recursive = TRUE, full.names = TRUE)

# Extract sample name and mean coverage
data <- map_df(files, function(f) {
  lines <- readLines(f)
  coverage_line <- grep("mean coverage", lines, value = TRUE)
  coverage <- as.numeric(str_extract(coverage_line, "\\d+\\.\\d+"))
  sample <- basename(dirname(f))
  tibble(sample = sample, coverage = coverage)
})

# Plot
p <- ggplot(data, aes(x = reorder(sample, -coverage), y = coverage)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Genome Coverage per Sample", x = "Sample", y = "Mean Coverage (X)")

# Save
ggsave(output_file, p, width = 10, height = 8)

message("✅ Plot saved to: ", output_file)
