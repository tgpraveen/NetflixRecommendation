#!/bin/sh

for file in *.txt
do
#echo $file
movieid=`sed -n 1p $file`
movieid=${movieid%?}
#echo $movieid
sed -n 1d $file>cat $file
sed -n s/.*/.*,$movieid/g > cat $file

done


