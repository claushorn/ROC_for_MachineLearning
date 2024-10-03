library(VUROCS)
package <- "VUROCS"

path <- "/Users/ch2437/code/ROC_AUC/"

# Initialize vectors to store results
results <- data.frame(n_samples = numeric(), signal_to_noise_ratio = numeric(), time = numeric(), auc = numeric())

# Outer loop over signal_to_noise_ratio
signal_to_noise_ratios <- c(0.1, 0.5, 2)
n_samples_values <- c(1E3,1E5,1E7)

for (snr in signal_to_noise_ratios) {
  for (n_samples in n_samples_values) {
    filename <- paste0(path,"data_nsamples_", n_samples, "_snr_", snr, ".RData")
    load(filename)
    exec_time <- system.time({
      auc_value <- VUS(data$response, data$predictor)[1] # with as.factor: Error in if (cat == 1) { : argument is of length zero
    })[3]
    results <- rbind(results, data.frame(n_samples = n_samples, signal_to_noise_ratio = snr, time = exec_time, auc = auc_value))
    print(paste("Processed data from", filename, "in", exec_time, "seconds, AUC:", auc_value))
  }
}

results <- results %>%
  rename(auc = val) 
         
# Write the results to a file
save(results, file = paste0(path,"results_",package, ".RData"))
