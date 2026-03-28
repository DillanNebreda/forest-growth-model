# Forest Growth Modeling with Synthetic Data

## Overview
This project demonstrates a reproducible workflow for modeling forest growth using synthetic data. It focuses on nonlinear regression using a Weibull growth model to simulate and analyze diameter growth across species.

## Objectives
- Simulate structured forest growth data
- Fit nonlinear Weibull growth models
- Compare growth patterns between species
- Evaluate model performance using RMSE
- Visualize observed vs fitted values

## Dataset
Synthetic dataset with experimental structure:

- 3 species:
  - Pinus radiata
  - Eucalyptus globulus
  - Nothofagus dombeyi
- 2 trays per species
- 70 plants per tray
- 8 measurements (every 15 days)

Total observations: 3360

### Variables
- `species`
- `tray`
- `plant_id`
- `measurement`
- `days`
- `diameter_cm`
- `height_cm`

## Methods

### Growth Model
A Weibull-type growth function was used:

y = a * (1 - exp(-b * x^c))

Where:
- `a` = asymptotic maximum size
- `b` = growth rate
- `c` = shape parameter

### Model Fitting
Models were fitted per species using nonlinear least squares:

- Method: `nlsLM`
- Package: `minpack.lm`

### Model Evaluation
Model performance was evaluated using:

- RMSE (Root Mean Squared Error)
- Relative RMSE (% of mean diameter)

Results showed RMSE values around 10–12%, indicating a good fit given simulated variability.

## Visualization
Observed vs fitted growth curves were plotted for each species, showing that the Weibull model captures general growth trends.

## Project Structure

## Requirements
```r
install.packages("tidyverse")
install.packages("minpack.lm")

## Technical Highlights
- Weibull nonlinear growth modeling
- Structured synthetic dataset
- Species-level model fitting
- RMSE-based model evaluation
- Visualization of observed vs fitted data