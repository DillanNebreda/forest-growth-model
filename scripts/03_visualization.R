library(tidyverse)
library(minpack.lm)

# -----------------------------
# 1. Load data
# -----------------------------
data <- read_csv("data/processed/synthetic_forest_growth.csv") %>%
  drop_na(diameter_cm)

# -----------------------------
# 2. Weibull function
# -----------------------------
weibull_model <- function(x, a, b, c) {
  a * (1 - exp(-b * x^c))
}

# -----------------------------
# 3. Fit model + predict
# -----------------------------
fit_and_predict <- function(df) {
  
  model <- nlsLM(
    diameter_cm ~ weibull_model(days, a, b, c),
    data = df,
    start = list(
      a = max(df$diameter_cm),
      b = 0.01,
      c = 1
    )
  )
  
  df %>%
    mutate(
      fitted = predict(model)
    )
}

plot_data <- data %>%
  group_by(species) %>%
  group_modify(~ fit_and_predict(.x)) %>%
  ungroup()

# -----------------------------
# 4. Plot
# -----------------------------
p <- ggplot(plot_data, aes(x = days)) +
  geom_point(aes(y = diameter_cm), alpha = 0.4) +
  geom_line(aes(y = fitted), color = "blue", linewidth = 1) +
  facet_wrap(~ species) +
  labs(
    title = "Observed vs Fitted Growth (Diameter)",
    x = "Days",
    y = "Diameter (cm)"
  ) +
  theme_minimal()

print(p)

ggsave(
  filename = "outputs/diameter_growth_plot.png",
  plot = p,
  width = 8,
  height = 5,
  dpi = 300
)

# -----------------------------
# 5. RMSE calculation
# -----------------------------
rmse_results <- plot_data %>%
  group_by(species) %>%
  summarise(
    RMSE = sqrt(mean((diameter_cm - fitted)^2)),
    mean_diameter = mean(diameter_cm),
    RMSE_percent = (RMSE / mean_diameter) * 100
  )

print(rmse_results)