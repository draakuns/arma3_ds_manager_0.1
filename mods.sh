#!/bin/bash

#Debug mode
#set -x 

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

#Grab the favourites from steam workshop web
fn_workshop_get_modlist_from_web
#Add the new subscribed content to the modlist file (Or create it if not exists)
fn_write_modlist_to_file

#Populates modlist for type and name, then also downloads it
fn_populate_modlist_and_dl_mod

#ALL the script starts here
#cat ${MODSMGT}/modlist.txt | awk -F":" '{print $1" "$2" "$3}'| while read MODNUMBER MODTYPE MODNAME ; do 
#
#	#if no type & name, then it's a new mod/miss
#	if [ -z "${MODTYPE}" ]; then 
#		#MOD NOT DL'd, START DOWNLOAD OF THE MOD
#		echo "${MODSMGT}/download_mod.sh ${MODNUMBER}"
#		${MODSMGT}/download_mod.sh ${MODNUMBER}
#		#GRAB TYPE
#		if [ -e ${WORKSHOP_DIR}/${MODNUMBER}/meta.cpp ]; then 
#			MODTYPE="MOD"
#		else
#			MODTYPE="MIS"	
#		fi
#		#GRAB NAME
#		if [ "${MODTYPE}" == "MOD" ]; then
#			#GRAB NAME FROM meta.cpp  (ADDS @)
#			MODNAME="@"$(fn_grab_mod_name_from_metacpp "${MODNUMBER}")
#		elif [ "${MODTYPE}" == "MIS" ]; then
#			#GRAB NAME AND MAP FROM WEB
#			MODNAME=$(fn_grab_mission_name_from_web "${MODNUMBER}")
#			MODNAME2=$(fn_grab_mission_map_from_web "${MODNUMBER}")
#			MODNAME=$(echo ${MODNAME}"."${MODNAME2}".pbo")
#		fi		
#
#	#echo $MODNUMBER; echo $MODTYPE ; echo $MODNAME
#	#echo "sed -i 's/${MODNUMBER}/${MODNUMBER}:${MODTYPE}:${MODNAME}/g' ${MODSMGT}/modlist.txt"
#		if [ -n "${MODNUMBER}" -a -n "${MODTYPE}" -a -n "${MODNAME}" ]; then
#			sed -i "s/${MODNUMBER}/${MODNUMBER}:${MODTYPE}:${MODNAME}/g" ${MODSMGT}/modlist.txt
#		else 
#			echo "Not possible to fetch all the values to fill in the modlist.txt for a new item"
#			exit 101
#		fi
#	fi # END OF NEW MODS/MISSIONS
#
#echo $MODNUMBER; echo $MODTYPE ; echo $MODNAME
#AHORA QUEDA LEER EL MODLIST Y CREAR LOS LINKS
#
#done

#Al final hay que chequear que todos los mods estan bajados

##############################################################################
