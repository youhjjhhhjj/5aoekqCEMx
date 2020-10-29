#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from https://www.voterstudygroup.org/publication/nationscape-data-set
# Author: Allen Li
# Data: 2 November 2020
# Contact: allenx.li@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(haven)
library(tidyverse)
setwd("C:/Users/Allen/Desktop")
# Read in the raw data
raw_data <- read_dta("ns20200625/ns20200625.dta")
# Add the labels
raw_data <- labelled::to_factor(raw_data)
# Just keep some variables
reduced_data <- 
  raw_data %>% 
  select(vote_2020,
         gender,
         race_ethnicity,
         education,
         age)

reduced_data <- filter(reduced_data, age >= 18)

reduced_data <-
  reduced_data %>% 
  rename(sex = gender) %>% 
  rename(race = race_ethnicity)
race_vector <- vector(mode="character", length=15)
race_vector[1:5] = c("White", "Black", "Native American", "Asian or Pacific Islander", "Chinese")
race_vector[6:14] = "Asian or Pacific Islander"
race_vector[15] = "Other"
levels(reduced_data$race) <- race_vector
reduced_data$education <- recode(reduced_data$education, "Middle School - Grades 4 - 8"="Middle School", "Other post high school vocational training"="High school graduate", "College Degree (such as B.A., B.S.)"="Bachelors Degree", "Completed some graduate, but no degree"="Bachelor Degree")

reduced_data <- filter(reduced_data, vote_2020 == "Donald Trump" | vote_2020 == "Joe Biden")

reduced_data<-
  reduced_data %>%
  mutate(vote_trump = 
           ifelse(vote_2020=="Donald Trump", 1, 0))

write_csv(reduced_data, "survey_data.csv")

