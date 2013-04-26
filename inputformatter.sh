#!/bin/sh

for file in *.txt
do
#echo $file
movieid=`sed -n 1p $file`
movieid=${movieid%?}
#echo $movieid
sed -i "1,1d" $file
sed -i 's/.*/&,'$movieid'/g' $file
done


