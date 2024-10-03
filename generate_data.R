library(pROC)
path <- "/Users/ch2437/code/ROC_AUC/"

generate_synthetic_data <- function(n_samples, signal_to_noise_ratio) {
  # Generate binary response variable
  response <- rbinom(n_samples, 1, 0.5)
  
  # Generate predictor variable with specified signal-to-noise ratio
  signal <- response * signal_to_noise_ratio
  noise <- rnorm(n_samples, mean = 0, sd = 1)
  predictor <- signal + noise
  
  return(list(response = response, predictor = predictor))
}

# Outer loop over signal_to_noise_ratio
signal_to_noise_ratios <- c(0.1, 0.5, 2)
#n_samples_values <- seq(1000, 1E7, length.out = 10)
n_samples_values <- c(1E3,1E5,1E7)

for (snr in signal_to_noise_ratios) {
  for (n_samples in n_samples_values) {
    data <- generate_synthetic_data(n_samples, snr)
    filename <- paste0(path,"data_nsamples_", n_samples, "_snr_", snr, ".RData")
    save(data, file = filename)
    print(paste("Saved data to", filename))
  }
}