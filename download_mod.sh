#!/bin/bash

### $1 being the workshop item to download

. cfg

fn_steamcmd_dl(){
${STEAM_EXE} +login ${STEAMUSR} ${STEAMPWD} +force_install_dir ${MOD_DIR} +"workshop_download_item 107410 $1" validate +quit
}

fn_steamcmd_status(){
${STEAM_EXE} +login ${STEAMUSR} ${STEAMPWD} +force_install_dir ${MOD_DIR} +"workshop_status $1" +quit
}

#Main
fn_steamcmd_dl "$1"
#fn_steamcmd_status "$WS_ARMAID"
#fn_steamcmd_status "$WS_ARMADSID"
