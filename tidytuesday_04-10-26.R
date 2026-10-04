# Load libraries
library(tidyverse)
library(tidytuesdayR)

# Load data
tuesdata <- tidytuesdayR::tt_load('2026-09-22')
urban <- tuesdata$urban #this takes the urban dataset from the list of datasets in tuesdata

# Inspect data
glimpse(urban)
head(urban)
summary(urban)

#Questions:
    # What city has the highest percentage of green space in urban areas in most recent year available?
    # What region has the highest average percentage of green space in urban areas?
    # What is the relationship between average percentage of green space and green space per capita?
    # How has the percentage of green space in urban areas changed over time for different regions?

# Data cleaning and wrangling
View(urban)

greenest_cities <- urban |>
    filter(year == 2025) |>
    filter(!is.na(averageShareOfGreenAreaInCityUrbanAreaPct)) |>
    arrange(desc(averageShareOfGreenAreaInCityUrbanAreaPct))

greenest_cities |>
    select(cityName,
         countryOrTerritoryName,
         year,
         averageShareOfGreenAreaInCityUrbanAreaPct) |>
    head()
    #View()

# Bar chart of top 10 cities with highest percentage of green space in urban areas
top_10_cities <- greenest_cities |>
  slice_head(n = 10)

ggplot(
  top_10_cities,
  aes(
    x = averageShareOfGreenAreaInCityUrbanAreaPct,
    y = reorder(cityName, averageShareOfGreenAreaInCityUrbanAreaPct)
  )
) +
  geom_col() +
  labs(
    title = "Cities with the highest share of green urban area in 2025",
    x = "Green area (%)",
    y = "City"
  )