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
# View(urban)
# What city has the highest percentage of green space in urban areas in most recent year available?
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

greenest_cities_plot <- ggplot(
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

  # Which city had the largest decline in the percentage of its urban area that was green between 1990 and 2025?
city_change <- urban |>
  filter(year %in% c(1990, 2025)) |>
  filter(!is.na(averageShareOfGreenAreaInCityUrbanAreaPct)) |>
  select(
    cityCode,
    cityName,
    countryOrTerritoryName,
    year,
    averageShareOfGreenAreaInCityUrbanAreaPct
  ) |>
  pivot_wider(
    names_from = year,
    values_from = averageShareOfGreenAreaInCityUrbanAreaPct,
    names_prefix = "green_"
  ) |>
  filter(!is.na(green_1990), !is.na(green_2025)) |>
  mutate(
    change = green_2025 - green_1990
  ) |>
  arrange(change)

largest_losses <- city_change |>
  slice_head(n = 10)

  # Negative bar chart for top 10 cities with largest decline in percentage of green space
loss_plot <- ggplot(
  largest_losses,
  aes(
    x = change,
    y = reorder(cityName, change)
  )
) +
  geom_col() +
  labs(
    title = "Cities with the largest declines in urban green space",
    subtitle = "Change in the share of urban area classified as green, 1990–2025",
    x = "Change in green area (percentage points)",
    y = "City"
  )

print(loss_plot)