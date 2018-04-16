fn_grab_mission_name_from_web()
{
#curl -s https://steamcommunity.com/sharedfiles/filedetails/?id=${1} |grep "Subscribe to download" |awk -F"<br>" '{print $2}' | awk -F"<" '{print $1}' | tr ' ' '_'
curl -s ${WORKSHOP_URL}${1} |grep "Subscribe to download" |awk -F"<br>" '{print $2}' | awk -F"<" '{print $1}' | tr ' ' '_'
}

fn_grab_mission_map_from_web()
{
#curl -s https://steamcommunity.com/sharedfiles/filedetails/?id=${1} |grep "Scenario Map" | awk -F"Scenario Map" '{print $2}' | awk -F"requiredtags%5B%5D=" '{print $2}' | awk -F"\"" '{print $1}'
curl -s ${WORKSHOP_URL}${1} |grep "Scenario Map" | awk -F"Scenario Map" '{print $2}' | awk -F"requiredtags%5B%5D=" '{print $2}' | awk -F"\"" '{print $1}'
}

fn_grab_mod_name_from_metacpp()
{
grep name ${WORKSHOP_DIR}/${1}/meta.cpp | tr -d "-" | tr -s ' ' '_' | awk -F"\"" '{print $2}'
}

fn_workshop_get_total_pages()
{
NUMTOTALPAGES=$(curl -s "https://steamcommunity.com/profiles/${WORKSHOP_ID}/myworkshopfiles/?browsesort=myfavorites&browsefilter=myfavorites&p=1&numperpage=${NUMITEMSPERPAGE}" | awk -F" " -v NUMITEMSPERPAGE=${NUMITEMSPERPAGE} ' /PagingInfo/ {print int($5/ NUMITEMSPERPAGE +1) }' )
}

fn_workshop_get_modlist_from_web()
{
fn_workshop_get_total_pages
REMAININGITEMS=${NUMTOTALPAGES}
CURRPAGE=1
while [ ${REMAININGITEMS} -gt 0 ];  
do
#echo "${REMAININGITEMS}"
MODLISTWEB+=$(curl -s "https://steamcommunity.com/profiles/${WORKSHOP_ID}/myworkshopfiles/?browsesort=myfavorites&browsefilter=myfavorites&p=${CURRPAGE}&numperpage=${NUMITEMSPERPAGE}" | grep -i filede | grep div | awk -F"\"" '{print $2}' | awk -F"=" '{print $2}' )
MODLISTWEB+=" "
let "REMAININGITEMS=REMAININGITEMS-1"
let "CURRPAGE=CURRPAGE+1"
done
}

fn_write_modlist_to_file()
{
for MOD in ${MODLISTWEB}; do
if [ ! $(grep ${MOD} ${MODSMGT}/modlist.txt) ]; then
echo ${MOD} >> "${MODSMGT}/modlist.txt"
fi
done
}


