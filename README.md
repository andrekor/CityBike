# CityBike
Statistical analysis of the Oslo city bike

The API calls are added to a cron job. The availability data is fetched each 10 minutes, the weather data is fetched each hour, and the station data is fetched each day

The cronjobs are as follows:

*/10 * * * * cd ~/CityBike/script/ && ./bysykkel.sh

0 12 * * * cd ~/CityBike/script/ && ./newStations.sh

0 * * * * cd ~/CityBike/script/ && ./weather.sh


## Prediction
There are multiple values to base the predictio of the availability for each rack. 
From the weather data, we use:
* temperature
* cloudy/sun/rain/etc..

From the bike api data, we use:
* id - representing a unique rack
* time - time of the sample
* availabilityRate, calculated based on number of available bikes and locks

From the station api data, we use:
* the name of the rack ID, (not really needed for the prediction)

When training the prediction model the target will be the availabilityRate. 

Algorithms (to be defined):

