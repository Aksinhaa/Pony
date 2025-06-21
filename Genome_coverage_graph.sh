

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


or 


library(tidyverse)
library(scales)  # for formatting

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

# Plot with enhancements
p <- ggplot(data, aes(x = reorder(sample, coverage), y = coverage, fill = coverage)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  geom_text(aes(label = round(coverage, 2)), hjust = -0.2, size = 3) +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  theme_minimal(base_size = 14) +
  labs(
    title = "Genome Coverage per Sample",
    x = "Sample",
    y = "Mean Coverage (X)",
    fill = "Coverage"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 10),
    legend.position = "right"
  ) +
  expand_limits(y = max(data$coverage) * 1.1)  # Add space for text

# Save
ggsave(output_file, p, width = 12, height = 8)

message("✅ Plot saved to: ", output_file)
