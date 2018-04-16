#!/bin/bash

#ERRORLEVELS
#100: modlist no existe
#101: Not possible to fetch all the values to fill in the modlist.txt for a new item

. ./cfg
. ./functions.sh


fn_workshop_get_modlist_from_web
fn_write_modlist_to_file


##############################################################################
