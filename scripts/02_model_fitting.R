library(tidyverse)
library(minpack.lm)

# -----------------------------
# 1. Load data
# -----------------------------
data <- read_csv("data/processed/synthetic_forest_growth.csv")

# -----------------------------
# 2. Clean data
# -----------------------------
data_clean <- data %>%
  drop_na(diameter_cm)

# -----------------------------
# 3. Weibull function
# -----------------------------
weibull_model <- function(x, a, b, c) {
  a * (1 - exp(-b * x^c))
}

# -----------------------------
# 4. Fit model per species
# -----------------------------
results <- data_clean %>%
  group_by(species) %>%
  group_modify(~ {
    
    model <- tryCatch({
      nlsLM(
        diameter_cm ~ weibull_model(days, a, b, c),
        data = .x,
        start = list(
          a = max(.x$diameter_cm, na.rm = TRUE),
          b = 0.01,
          c = 1
        ),
        control = nls.lm.control(maxiter = 200)
      )
    }, error = function(e) {
      message(paste("failed at step model fitting:", e$message))
      return(NULL)
    })
    
    if (is.null(model)) {
      return(tibble(a = NA, b = NA, c = NA))
    }
    
    params <- coef(model)
    
    tibble(
      a = params["a"],
      b = params["b"],
      c = params["c"]
    )
  }) %>%
  ungroup()

# -----------------------------
# 5. Print results
# -----------------------------
print(results)
write_csv(results, "data/processed/model_parameters.csv")