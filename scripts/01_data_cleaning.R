library(tidyverse)

# -----------------------------
# 1. Experimental structure
# -----------------------------
species <- c("Pinus_radiata", "Eucalyptus_globulus", "Nothofagus_dombeyi")

data_structure <- expand_grid(
  species = species,
  tray = paste0("T", 1:2),
  plant_id = 1:70,
  measurement = 1:8
) %>%
  mutate(
    days = measurement * 15
  )

# -----------------------------
# 2. Parameters per species
# -----------------------------
params <- tibble(
  species = species,
  a = c(25, 35, 30),
  b = c(0.02, 0.015, 0.018),
  c = c(1.5, 1.3, 1.4)
)

data <- data_structure %>%
  left_join(params, by = "species")

# -----------------------------
# 3. Variability
# -----------------------------
data <- data %>%
  group_by(species, tray, plant_id) %>%
  mutate(plant_effect = rnorm(1, 0, 0.1)) %>%
  ungroup()

data <- data %>%
  group_by(species, tray) %>%
  mutate(tray_effect = rnorm(1, 0, 0.05)) %>%
  ungroup()

# -----------------------------
# 4. Generate growth
# -----------------------------
data <- data %>%
  mutate(
    diameter_cm = (a * (1 - exp(-b * days^c))) *
      (1 + plant_effect + tray_effect + rnorm(n(), 0, 0.05)),
    
    height_cm = (a * 2 * (1 - exp(-b * days^c))) *
      (1 + plant_effect + tray_effect + rnorm(n(), 0, 0.08))
  )

# Avoid negative values
data <- data %>%
  mutate(
    diameter_cm = pmax(diameter_cm, 0.01),
    height_cm = pmax(height_cm, 0.01)
  )

# -----------------------------
# 5. Add missing values
# -----------------------------
set.seed(123)

data <- data %>%
  mutate(
    diameter_cm = ifelse(runif(n()) < 0.05, NA, diameter_cm),
    height_cm = ifelse(runif(n()) < 0.05, NA, height_cm)
  )

# -----------------------------
# 6. Save dataset
# -----------------------------
write_csv(data, "data/processed/synthetic_forest_growth.csv")

# -----------------------------
# 7. Quick check
# -----------------------------
print(nrow(data))