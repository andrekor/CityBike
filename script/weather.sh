#!/bin/bash

now=`date +"%Y-%m-%d:%H:%M"`
wget http://www.yr.no/stad/Noreg/Oslo/Oslo/Oslo/varsel.xml -O "bysykkelData/weather/$now.txt"
