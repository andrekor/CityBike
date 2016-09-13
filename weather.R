library(XML)

parseForcast <- function(path) {
  forecast <- xmlParse(path)
  xml_data <- xmlToList(forecast)
  dateFromFile <- gsub(".*/(.*)\\.+.*", "\\1", path)
  timeStamp <- strptime(dateFromFile, format ="%Y-%m-%d-%H-%M-%S")
  
  temp <- xml_data$observations$weatherstation$temperature[[2]]
  time <- xml_data$observations$weatherstation$temperature[[3]]
  note <- xml_data$observations$weatherstation$symbol[[2]]
  if (is.null(note)) {
    note <- "No description"
  }
  weatherData <- data.frame(temperature=temp, 
                            timeStamp = time, 
                            note = note)
  return (weatherData)
}

readWeatherFiles <- function(dirPath) {
  fileNames <- list.files(dirPath, pattern = "*.xml", full.names = TRUE)
  ldf <- lapply(fileNames, parseForcast)  
  completeDataSet <- rbind.fill(ldf)
  return (completeDataSet)
}