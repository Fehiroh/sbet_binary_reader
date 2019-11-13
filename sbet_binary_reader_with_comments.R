
# Libraries #########################################################################
library(dplyr)
library(lubridate)
library(tibble)
library(magrittr)



# Inputs ############################################################################

# filepath is the filepath to the .out file you want to examine
filepath <- "C:/Users/h.malik/Desktop/sbet_lv201910110850.out" # CHANGE_NECESSARY

# myerro is the  time value/s that you want to see 
myerro <- c(449128) #CHANGE_NECESSARY



# Getting Binary ####################################################################

# We know the files are stored as binary files with 8 byte doubles.
# Reading speed is improved exponentially by feeding the exact size into the n
# arg of readBin

fp <- file(filepath, "rb")

fp_info <- file.info(filepath)

icount <- readBin(fp, double(), size=8, n=fp_info$size)


# It has 17 columns. The columns we want are 1, 2, and 3, which represent:
# 1) time, 2) x coordinates, and 3) y corrdinates, the relevant indices for these values within
# the icount vector are obtained using seq() 

time_indices <- seq(1, by = 17, length(icount))

x_indices <- seq(2, by = 17, length(icount))

y_indices <- seq(3, by = 17, length(icount))


# Generating a df called storage to house the results. Matched nrow to the
# length of the data it will store to facilitate quick data transfer using base
# R

storage <- as.data.frame(matrix(ncol = 3, nrow = length(time_indices)))

storage_names <- c("time", "x", "y")

names(storage) <- storage_names


# Using the indices to subset icount, and then store the vectors in the
# preprepared df, storage.
temptimeDataFrame <- icount[c(time_indices)]
names(temptimeDataFrame) <- storage_names[1]

tempxDataFrame <-  icount[c(x_indices)]
names(tempxDataFrame) <- storage_names[2]

tempyDataFrame <-icount[c(y_indices)]
names(tempyDataFrame) <- c("y")

storage$time <- temptimeDataFrame
storage$x <- tempxDataFrame
storage$y <- tempyDataFrame

storage <- as.data.frame(storage)


# Filtering Results ##############################################################

# returns a df names errors containing the geospatial coordinates at the
# specified time/s
errors <- storage[as.integer(storage$time, 0) %in% myerro,]

# TODO: STILL TO DO IS SELECT DISTINCT TIME,X,Y 

