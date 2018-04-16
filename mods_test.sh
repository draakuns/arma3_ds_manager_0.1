#!/bin/bash

#Enable debug
# set -x

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

fn_workshop_get_modlist_from_web

#fn_workshop_get_total_pages
#REMAININGITEMS=${NUMTOTALPAGES}
#CURRPAGE=1
#while [ ${REMAININGITEMS} -gt 0 ];  
#do
##echo "${REMAININGITEMS}"
#WORKSHOPFAVS+=$(curl -s "https://steamcommunity.com/profiles/${WORKSHOP_ID}/myworkshopfiles/?browsesort=myfavorites&browsefilter=myfavorites&p=${CURRPAGE}&numperpage=${NUMITEMSPERPAGE}" | grep -i filede | grep div | awk -F"\"" '{print $2}' | awk -F"=" '{print $2}' )
#WORKSHOPFAVS+=" "
#let "REMAININGITEMS=REMAININGITEMS-1"
#let "CURRPAGE=CURRPAGE+1"
#done

echo ${MODLISTWEB}
