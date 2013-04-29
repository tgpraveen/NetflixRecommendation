#!/bin/sh

if [ $# -eq 1 ]
then
	for file in $1/*.txt
	do
		#echo $file
		movieid=`sed -n 1p $file`
		movieid=${movieid%?}
		#echo $movieid
		sed -i "1,1d" $file
		sed -i 's/.*/&,'$movieid'/g' $file
	done
else
	echo 'Incorrect number of arguments: ' $#
	echo '<Usage> ./script <path to movie ratings folder>'
fi
