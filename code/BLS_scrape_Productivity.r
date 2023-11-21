# CAdams: I was having issues loading the github packages and had to: uninstall dependent packages, change path to a folder in Documents
# install the packages again (I addded the path when installing just to be sure), update R because there is a new version, and finally was
# able to run install_github("mikesilva/blsAPI")
# remove.packages("devtools")
# remove.packages("vctrs")
# remove.packages("rlang")
# remove.packages("cli")
# remove.packages("jsonlite")
# remove.packages("curl")
# remove.packages("dplyr")
# remove.packages("tidyverse")
# .libPaths("C:/Users/cassi/Documents/R")
# .libPaths()
# install.packages("devtools", lib = "C:/Users/cassi/Documents/R")
# install.packages("usethis", lib = "C:/Users/cassi/Documents/R")
# install.packages("vctrs", lib = "C:/Users/cassi/Documents/R")
# install.packages("rlang", lib = "C:/Users/cassi/Documents/R")
# install.packages("cli", lib = "C:/Users/cassi/Documents/R")
# install.packages("jsonlite", lib = "C:/Users/cassi/Documents/R")
# install.packages("rjson", lib = "C:/Users/cassi/Documents/R")
# install.packages("dplyr", lib = "C:/Users/cassi/Documents/R")
# install.packages("curl", lib = "C:/Users/cassi/Documents/R")
# install.packages("zeallot", lib = "C:/Users/cassi/Documents/R")
# install.packages("tidyverse", lib = "C:/Users/cassi/Documents/R")
# install.packages("installr", lib = "C:/Users/cassi/Documents/R")
# library(installr)
# updateR()
# library(devtools)
# library(tidyverse)
# library(dplyr)
# install_github("mikeasilva/blsAPI")                           # Credit to mikeasliva for the blsAPI GitHub and associated documentation.

# CAdams: With install_github("mikesilva/blsAPI") successfuly loaded, the devtools, dplyr, tidyverse, and "blsAPI" librarires need to be loaded each time the code is run
library(devtools)
library(dplyr)
library(tidyverse)
library("blsAPI")

# Defines the data that is to be pulled from the API
# The series ID's define the "data columns" to be pulled from BLS
# The start and end year define the period over which to pull.
payload <- list(
    "seriesid" = c("PRS85006033", "PRS85006043", "PRS85006093"),
    "startyear" = 2012,
    "endyear" = 2022
)

# Query the BLS API for the data we requested,
# specify API version 2.0, request result as a dataframe
response <- blsAPI(payload, 2, return_data_frame = TRUE)

# Pivot the datafarme to get the data in separate columns
df = response %>%
    pivot_wider(
        names_from = seriesID,
        values_from = value,
        values_fill = NULL
    )

# Rename the data columns to something meaningful
df = rename(df, 
        hours = PRS85006033,
        output = PRS85006043,
        productivity = PRS85006093
    )

# Sort the data by year then quarter
df = arrange(df, year, period)

# Convert columns to appropriate data types
df$year = as.integer(df$year)
df$hours = as.numeric(df$hours)
df$output = as.numeric(df$output)
df$productivity = as.numeric(df$productivity)
# df

# Set working directory to the data fold and save as CSV, but changed to comment line to force checking path before doing this
# setwd("C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data")      
# bls_file = write.csv(df, file = "bls_clean.csv", row.names = FALSE)

