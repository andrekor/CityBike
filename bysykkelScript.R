library(jsonlite)
library(ggplot2)
library(ggvis)
library(lubridate)
library(plyr)

source("Documents/CityBike/CityBike/weather.R")
source("Documents/CityBike/CityBike/bysykkelDataFiltering.R")


#Make station and rack data ready for analysis
#The data must be put into one folder containting only this
station_data <- stationFunction("Bysykkel/station.json") #should use the latest version, or make a table over time
availabilityData <- readBysykkelFiles("Downloads/data/availability/")
availabilityData <- availabilityData[!is.na(availabilityData$time) & !is.na(availabilityData$availabilityRate),]

#Make weather data ready
weather  <- readWeatherFiles("Downloads/data/weather/")
weather$temperature <- as.double(levels(weather$temperature))[weather$temperature] #Converting from factor to double
#weather$timeStamp <- as.POSIXct(weather$timeStamp, format="%Y-%m-%d %H:00")
weather$timeStamp <- as.POSIXct(weather$timeStamp, format="%Y-%m-%dT%H:%M:%SZ")
weather$dateTime <- format(weather$timeStamp, "%Y-%m-%d %H:00");

#Merge the availability data with the station data for more description and info 
descriptionData <- merge(availabilityData, station_data$stations[c("id", "title")], by="id")

#Need to make a function to fill in the temperature to nearest hour for the descriptionData
names(descriptionData)

#Create target values. Optimal target : 50% ([20-50], [50-20])
descriptionData$target <- lapply(descriptionData$availabilityRate, generateIntervals) 

#maps the time to a value, for the predicitons (is this needed??)
#descriptionData$timeAsDecimal <- lapply(descriptionData$time, makeTimeAsDecimal)

names(descriptionData)


getRackData <- function(completeData, id) {
  return (completeData[completeData$id==id,])
}


makeDataFrameForUniqueTime <- function(dataSet) {
  getMedian <- function(time) {
    return (median(dataSet$availabilityRate[dataSet$time==time]))  
  }
  
  getStd <- function(time) {
    return (sd(dataSet$availabilityRate[dataSet$time==time]))  
  }
  
  getMean <- function(time) {
    return (mean(dataSet$availabilityRate[dataSet$time==time]))  
  }
  
  someDataFrame <- data.frame(time = unique(dataSet$time))
  someDataFrame$medianAvailability <- as.numeric(lapply(someDataFrame$time, getMedian))
  someDataFrame$standardDev <- as.numeric(lapply(someDataFrame$time, getStd))
  someDataFrame$meanAvailability <- as.numeric(lapply(someDataFrame$time, getMean))
  someDataFrame$weekDay <- dataSet$weekDay[1]
  return(someDataFrame)
}


makeProbabilityDataSet <- function(weekDay = "Monday") {
  timeOfDay <- as.POSIXct("2016-08-19 16:10:01", format="%Y-%m-%d %H:00")
  #weekDay <-  weekdays(timeOfDay)
  d <- strftime(timeOfDay, format="%Y-%m-%d") #Target day 
  t <- strftime(timeOfDay, format="%H:%M") #Target time

  #Filter on the correct day
  dayData <- availabilityData[weekDay==weekdays(availabilityData$date),]
  #Gets the interesting fields
  dayData <- dayData[c("id", "availabilityRate", "time", "date")]
  dayData$time <- strftime(dayData$time, format="%H:%M")
  #dayData$dateTime <- strftime(dayData$time, format="%Y-%m-%d %H:00")
  dayData$nearestHour <- format(dayData$time, format = "%H:00")
  dayData$weekDay <- weekDay


  combineData <- function(id) {
    combined <- makeDataFrameForUniqueTime(getRackData(dayData, id))
    combined$id <- id
    return (combined)
  }
  
  ldf <- lapply(unique(dayData$id), combineData)
  aa <- rbind.fill(ldf)

  #completeDataSet <- merge(dayData, weather, by ="dateTime", all.x = TRUE)
  return (aa)
}

plotSomething <- function(dataToPlot) {
  #plot each of the stations
  ggplot(data=dataToPlot, aes(x=time, y=meanAvailability, group=id, colour=as.factor(id))) +
    geom_line() +
    geom_point() + theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 11),
                         legend.position="bottom", legend.direction="vertical") 
}
  

combineAllDays <- function(){
  allWeekdays <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  ldf <- lapply(allWeekdays, makeProbabilityDataSet)
  totalDataSet <- rbind.fill(ldf)
  return (totalDataSet)
}


getProbability <- function() {
  timeOfDay <- as.Date("2016-08-19 16:10:00")
  t <- strftime(timeOfDay, format="%H:%M") #Target time
  weekdays(timeOfDay)
  a <- combineAllDays()
  jsonFile <- toJSON(a, pretty=TRUE)
  write(jsonFil, "test.json")
}



#Test*************************************************
#Majorstua has id: 189. 
majorstua <- availabilityData[availabilityData$id==189,]

unique(majorstua$date)
majorstua19 <- majorstua[majorstua$date==as.Date("2016-08-19"),]
majorstua19 <- majorstua19[c("availabilityRate", "time")]

#ggplot(data=majorstua[majorstua$weekday=="Monday",], aes_string(x="time", y="availabilityRate", fill=as.factor("weekDay"))) + geom_point(shape=1)

ggplot(data=availabilityData[availabilityData$id==189,], aes_string(x="time", y="availabilityRate", fill=factor("id"))) + 
  geom_point(shape=1) 

ggplot(data=weather[15:32,], aes(x=timeStamp, y=temperature, fill=temperature)) + 
  geom_point(shape=1) + theme(axis.text.x = element_text(angle = 30, hjust = 1))


