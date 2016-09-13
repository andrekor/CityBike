#!/bin/bash
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

now=`date +"%Y-%d-%m:%H:%M"`
wget https://oslobysykkel.no/api/v1/stations/availability -O "bysykkelData/$now.txt"
