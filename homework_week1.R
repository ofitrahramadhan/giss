#CREATED BY: FITRAH RAMADHAN (22229766)#

##STEP 1: INSTALL AND LOAD PACKAGES
install.packages(c("sf","tmap","tmaptools","RSQLite"))
install.packages("tidyverse")

library(sf)
library(tmap)
library(tmaptools)
library(RSQLite)
library(tidyverse)

####################################################################################################################

##STEP 2: CHANGE WORK DIRECTORY
wd <- "D:/Fitrah Ramadhan/Study/MSc Urban Spatial Science/1. Course/CASA0005 - Geographic Information Systems and Science/Practical/Week 1/Homework"
setwd(wd)
list.files(wd, pattern=NULL, all.files=FALSE, full.names=FALSE)

####################################################################################################################

##STEP 3: LOAD DATA

###Load Spatial Data
map <- st_read("territorial-authority-2018-generalised.shp")
colnames(map)[1] <-"Area_Code"

####Summarize Spatial Data
summary(map)
plot(map)

map %>% st_simplify(., preserveTopology = TRUE, dTolerance = 100) %>%
  st_geometry() %>%
  plot()



###Load Attribute Data
attribute_data <- read_delim("data.csv", delim=";", col_names=TRUE)



####################################################################################################################

##STEP 4: JOIN DATA
map <- map%>%
  merge(.,
        attribute_data,
        by.x="Area_Code")

map["density"] <- map["Paid_employee"]/map["AREA_SQ_KM"]


####################################################################################################################


##STEP 5: VISUALIZE DATA
tmap_mode("view")
tm_shape(map) + tm_fill("Paid_employee", style="quantile", n=7, palette="Greens") + tm_borders(alpha=.4)