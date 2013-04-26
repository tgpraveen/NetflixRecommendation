#!/bin/sh

for file in *.txt
do
#echo $file
movieid=`sed -n 1p $file`
movieid=${movieid%?}
echo $movieid
sed 1d $file
sed s/.*/.*/$movieid

done


