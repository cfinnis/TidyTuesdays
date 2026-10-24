library(tidyverse)
library(tidytuesdayR)

# Load data

tuesdata <- tidytuesdayR::tt_load('2026-07-28')

occurrences <- tuesdata$occurrences
tourism <- tuesdata$tourism
weather <- tuesdata$weather

# Inspect data
head(occurrences)
head(tourism)
head(weather)

view(occurrences)

# Data cleaning and wrangling
# How do observations of the different animals relate to numbers of tourists?
# How does the average temperature relate to the number of tourists?
# In which month were there the most observations for each organism?
