# CityBike
Statistical analysis of the Oslo city bike

The API calls are added to a cron job. The availability data is fetched each 10 minutes, the weather data is fetched each hour, and the station data is fetched each day

The cronjobs are as follows:

*/10 * * * * cd ~/CityBike/script/ && ./bysykkel.sh

0 12 * * * cd ~/CityBike/script/ && ./newStations.sh

0 * * * * cd ~/CityBike/script/ && ./weather.sh

