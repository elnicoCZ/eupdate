#!/bin/sh

param="$1"
input="$2"
output="$3"

case $param in
"-w" )
	echo "Convert unix to windows coding."
	cat $input |\
	sed 's/$'"/`echo \\\r`/"  > $output
;;
"-u" )
	echo "Convert windows to unix coding."
	cat $input |\
	sed 's/^M$//' > $output
;;
* )
	echo "Incorrect parametres!"
;;
esac
