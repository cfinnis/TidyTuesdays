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

observations_summary <- occurrences |>
  # create a column for the quarter from the month
  mutate(
    quarter = (month - 1) %/% 3 + 1
  ) |>
  # remove records without a weather station id
  filter(!is.na(ws_id)) |>
  group_by(
    ws_id, year, quarter, organism_name
  ) |>
  # count observations within each group
  summarise(
    observations = n(),
    .groups = "drop"
  )

head(observations_summary)


#calculate the total number of observations for each organism by year and Q

observations_plot <- observations_summary |>
  group_by(year, quarter, organism_name) |>
  summarise(
    total_observations = sum(observations),
    .groups = "drop"
  )

head(observations_plot)


ggplot(
  observations_plot,
  aes(
    x = year + (quarter - 1) / 4,
    y = total_observations,
    colour = organism_name
  )
) +
  geom_line(linewidth = 1) +
  facet_wrap(~ organism_name, scales = "free_y") +
  labs(
    title = "Wildlife observations over time",
    x = "Year",
    y = "Number of observations",
    colour = "Organism"
  ) +
  theme_minimal()

#save the graph 
ggsave(
  filename = "2026-07-28-ecotourism/figures/wildlife_observations.png",
  width = 10,
  height = 6,
  dpi = 300
)
# How does the average temperature relate to the number of tourists?
# In which month were there the most observations for each organism?