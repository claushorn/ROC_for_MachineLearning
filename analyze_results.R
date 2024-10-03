library(ggplot2)
library(dplyr)
library(tidyr)

# Define the packages and result files
packages <- c("ROCR", "pROC", "cvAUC", "VUROCS", "AUC") # "multiROC"
path <- "/Users/ch2437/code/ROC_AUC/"

# Initialize an empty data frame to store combined results
combined_results <- data.frame(n_samples = numeric(), signal_to_noise_ratio = numeric(), time = numeric(), auc = numeric(), package = character())
# Load and merge the result files
for (package in packages) {
  file <- paste0(path,"results_", package, ".RData")
  load(file)
  results$package <- package
  combined_results <- rbind(combined_results, results)
}

# make two datframes one with auc values, the other with times, columnns: n_samples, signal_to_noise_ratio, pROC, ROCR 
# Create separate data frames for AUC values and execution times
auc_df <- combined_results %>%
  select(n_samples, signal_to_noise_ratio, package, auc) %>%
  spread(key = package, value = auc)

time_df <- combined_results %>%
  select(n_samples, signal_to_noise_ratio, package, time) %>%
  #spread(key = package, value = time)
  pivot_wider(names_from = package, values_from = time)

# Rename columns for clarity
colnames(auc_df) <- c(c("n_samples","signal_to_noise_ratio"), packages)
colnames(time_df) <- c(c("n_samples", "signal_to_noise_ratio"), packages)

# Print the data frames
print("AUC Data Frame:")
print(auc_df)

print("Time Data Frame:")
print(time_df)

#options(scipen=1) # 999

# Reshape time_df to long format for ggplot2
time_long_df <- time_df %>%
  filter(n_samples == max(n_samples)) %>%
  gather(key = "package", value = "time", -n_samples, -signal_to_noise_ratio)

time_long_df$package = factor(time_long_df$package, levels = packages)

# Plot comparison of execution times
ggplot(time_long_df, aes(x = as.factor(signal_to_noise_ratio), y = time, fill = package)) +
  geom_bar(stat = "identity", position = "dodge") +
  #scale_x_continuous(labels = scales::comma) +
  #scale_x_discrete(labels = scales::comma) +
  labs(title = "", # "Execution Time Comparison"
       x = "Dataset (signal_to_noise_ratio)",
       y = "Execution Time (seconds)",
       fill = "Package") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1))