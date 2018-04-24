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

fn_tolower

fn_create_symlinks

#Copies mod keys to keys directory to avoid unsigned content warnings
fn_copy_keys


#Al final hay que chequear que todos los mods estan bajados

##############################################################################
