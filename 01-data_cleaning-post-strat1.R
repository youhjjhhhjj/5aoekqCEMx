#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from https://usa.ipums.org/usa/index.shtml
# Author: Allen Li
# Data: 2 November 2020
# Contact: allenx.li@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(haven)
library(tidyverse)
setwd("C:/Users/Allen/Desktop")
# Read in the raw data.
raw_data <- read_dta("usa_00002.dta.gz")
# Add the labels
raw_data <- labelled::to_factor(raw_data)
# Just keep some variables that may be of interest
reduced_data <- 
  raw_data %>% 
  select(sex, 
         age,
         race, 
         educd)
         
reduced_data <- rename(reduced_data, education = educd)
levels(reduced_data$sex) <- c("Male", "Female")

race_vector <- c("White", "Black", "Native American", "Chinese", "Asian or Pacific Islander", "Asian or Pacific Islander", "Other", "Other", "Other")
levels(reduced_data$race) <- race_vector

reduced_data <- filter(reduced_data, education != "missing")
education_vector <- vector(mode="character", length=44)
education_vector[1:10] = "3rd Grade or less"
education_vector[11:18] = "Middle School"
education_vector[19:23] = "Completed some high school"
education_vector[24:26] = "High school graduate"
education_vector[27:30] = "Completed some college, but no degree"
education_vector[31:33] = "Associate Degree"
education_vector[34:40] = "Completed some college, but no degree"
education_vector[36] = "Bachelors Degree"
education_vector[41:44] = c("Masters degree", "Masters degree", "Doctorate degree", "Doctorate degree")
levels(reduced_data$education) <- education_vector

reduced_data <- 
  reduced_data %>%
  count(age, sex, race, education) %>%
  group_by(age, sex, race, education) 

reduced_data$age <- as.integer(reduced_data$age)

reduced_data <- filter(reduced_data, age >= 18)

write_csv(reduced_data, "census_data.csv")



         