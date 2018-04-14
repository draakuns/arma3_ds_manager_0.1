#!/bin/bash

#ERRORLEVELS
#100: modlist no existe
#101: Not possible to fetch all the values to fill in the modlist.txt for a new item

. ./cfg
. ./functions.sh

#Deprecated against reading the favorites and modlisting it.
#if [ ! -e ${MODSMGT}/modlist.txt ]; then
#	echo "File ${MODSMGT}/modslist.txt doesn't exists."
#	exit 100
#fi

fn_workshop_get_total_pages
echo ${NUMTOTALPAGES}
#while [ $(fn_workshop_remaining_pages) -gt 0 ]; then 
#do
#echo "HOLA${REMAININGITEMS}"
#done	
