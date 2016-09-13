library(jsonlite)
library(ggplot2)
library(ggvis)
library(lubridate)

source("Documents/CityBike/CityBike/weather.R")
source("Documents/CityBike/CityBike/bysykkelDataFiltering.R")


#Make station and rack data ready for analysis
#The data must be put into one folder containting only this
station_data <- stationFunction("Bysykkel/station.json")
availabilityData <- readBysykkelFiles("Downloads/data/availability/")

#Make weather data ready
weather  <- readWeatherFiles("Downloads/data/weather/")
weather$temperature <- as.double(levels(weather$temperature))[weather$temperature] #Converting from factor to double

#Merge the availability data with the station data for more description and info 
descriptionData <- merge(availabilityData, station_data$stations[c("id", "title")], by="id")

#Majorstua has id: 189. 
majorstua <- availabilityData[availabilityData$id==189,]


ggplot(data=majorstua[majorstua$weekday=="Monday",], aes_string(x="time", y="availabilityRate", fill=as.factor("weekDay"))) + geom_point(shape=1)

ggplot(data=availabilityData[availabilityData$id==189,], aes_string(x="time", y="availabilityRate", fill=factor("id"))) + 
  geom_point(shape=1) 

ggplot(data=weather[15:32,], aes(x=timeStamp, y=temperature, fill=temperature)) + 
  geom_point(shape=1) + theme(axis.text.x = element_text(angle = 30, hjust = 1))
