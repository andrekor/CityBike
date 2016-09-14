#!/bin/bash

now=`date +"%Y-%m-%d:%H:%M"`
wget https://oslobysykkel.no/api/internal/stations -O "bysykkelData/stations/$now.txt"
