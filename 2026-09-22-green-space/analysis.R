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

# Data cleaning and wrangling
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

ggsave(
  "2026-09-22-green-space/figures/greenest_cities.png",
  plot = greenest_cities_plot,
  width = 10,
  height = 6,
  dpi = 300
)

  # Which cities experienced the largest decline in green space percentage between 1990 and 2025?
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
    change = green_2025 - green_1990,
    city_label = paste(cityName, countryOrTerritoryName, sep = ", ")
  ) |>
  arrange(change)

largest_losses <- city_change |>
  slice_head(n = 10)

  # Negative bar chart for top 10 cities with largest decline in percentage of green space
loss_plot <- ggplot(
  largest_losses,
  aes(
    x = change,
    y = reorder(city_label, change)
  )
) +
  geom_col() +
  labs(
    title = "Cities with the largest declines in urban green space",
    subtitle = "Change in the share of urban area classified as green, 1990–2025",
    x = "Change in green area (percentage points)",
    y = "City"
  )

ggsave(
  "2026-09-22-green-space/figures/largest_declines.png",
  plot = loss_plot,
  width = 10,
  height = 6,
  dpi = 300
)

# Which cities experienced the largest increase in green space percentage between 1990 and 2025?

city_increase <- urban |>
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
    change = green_2025 - green_1990,
    city_label = paste(cityName, countryOrTerritoryName, sep = ", ")
  ) |>
  arrange(desc(change))

largest_increases <- city_increase |>
  slice_head(n = 10)

# Positive bar chart for top 10 cities with largest decline in percentage of green space
increase_plot <- ggplot(
  largest_increases,
  aes(
    x = change,
    y = reorder(city_label, change)
  )
) +
  geom_col() +
  labs(
    title = "Cities with the largest increases in urban green space",
    subtitle = "Change in the share of urban area classified as green, 1990–2025",
    x = "Change in green area (percentage points)",
    y = "City"
  )

ggsave(
  "2026-09-22-green-space/figures/largest_increases.png",
  plot = increase_plot,
  width = 10,
  height = 6,
  dpi = 300
)