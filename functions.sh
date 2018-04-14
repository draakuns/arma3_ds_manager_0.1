
fn_grab_mission_name_from_web(){
#curl -s https://steamcommunity.com/sharedfiles/filedetails/?id=${1} |grep "Subscribe to download" |awk -F"<br>" '{print $2}' | awk -F"<" '{print $1}' | tr ' ' '_'
curl -s ${WORKSHOP_URL}${1} |grep "Subscribe to download" |awk -F"<br>" '{print $2}' | awk -F"<" '{print $1}' | tr ' ' '_'
}

fn_grab_mission_map_from_web(){
#curl -s https://steamcommunity.com/sharedfiles/filedetails/?id=${1} |grep "Scenario Map" | awk -F"Scenario Map" '{print $2}' | awk -F"requiredtags%5B%5D=" '{print $2}' | awk -F"\"" '{print $1}'
curl -s ${WORKSHOP_URL}${1} |grep "Scenario Map" | awk -F"Scenario Map" '{print $2}' | awk -F"requiredtags%5B%5D=" '{print $2}' | awk -F"\"" '{print $1}'
}

fn_grab_mod_name_from_metacpp(){
grep name ${WORKSHOP_DIR}/${1}/meta.cpp | tr -d "-" | tr -s ' ' '_' | awk -F"\"" '{print $2}'
}

fn_workshop_get_total_pages(){
local NUMITEMSPERPAGE=30
NUMTOTALITEMS = $(curl -s "https://steamcommunity.com/profiles/${WORKSHOP_ID}/myworkshopfiles/?browsesort=myfavorites&browsefilter=myfavorites&p=1&numperpage=${NUMITEMSPERPAGE}" |grep -i pagingInfo  | awk -F" " '{print $5}')
NUMTOTALPAGES = $( eval ( ${NUMTOTALITEMS} / ${NUMITEMSPERPAGE} ) )
}

fn_workshop_remaining_pages(){
return 
}
