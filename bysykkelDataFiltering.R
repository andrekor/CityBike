
getBysykkelDataSet <- function(json_file) {
  
  test_json <- (json_file)
  json_data <- fromJSON(test_json)
  
  dateFromFile <- gsub(".*/(.*)\\.+.*", "\\1", json_file)
  
  timeStamp <- strptime(dateFromFile, format ="%Y-%m-%d-%H-%M-%S")
  
  bysykkelData <- data.frame(id=json_data$stations$id, bikes=json_data$stations$availability$bikes, 
                             locks=json_data$stations$availability$locks, 
                             availabilityRate=c(json_data$stations$availability$bikes/(json_data$stations$availability$bikes+json_data$stations$availability$locks)), 
                             date=as.Date(json_data$updated_at),
                             time=timeStamp)
  return (bysykkelData)
}

readBysykkelFiles <- function(path) {
  fileNames <- list.files(path, pattern = "*.json", full.names = TRUE)
  ldf <- lapply(fileNames, getBysykkelDataSet)  
  completeDataSet <- rbind.fill(ldf)
  return (completeDataSet)
}

stationFunction <- function(path) {
  stations <- (path)
  station_data <- fromJSON(stations)
  return (station_data)
}

roundTime <- function(timeStamp) {
  format(strptime(as.Date(timeStamp), "%Y-%m-%d")+round(as.numeric(timeStamp)), "%H:%M")
}


generateIntervals <- function(rate) {
  if (is.na(rate)) {
    return ("0")
  }
  if (rate < 0.1) {
    return ("[0-10]")
  } 
  else if (rate < 0.2) {
    return ("[10-20]")
  }
  else if (rate < 0.5) {
    return ("[20-50]")
  }
  else if (rate < 0.8) {
    return ("[50-80]")
  }  
  else if (rate < 0.9){
    return ("[80-90]")
  }
  return ("[90-100]")
}

makeTimeAsDecimal <- function(time) {
  t.lub <- ymd_hms(time)
  h.lub <- hour(t.lub) + minute(t.lub)/60
  return(round(h.lub, digits = 2))
}



