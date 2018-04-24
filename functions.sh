
fn_grab_mission_name_from_web()
{
#curl -s https://steamcommunity.com/sharedfiles/filedetails/?id=${1} |grep "Subscribe to download" |awk -F"<br>" '{print $2}' | awk -F"<" '{print $1}' | tr ' ' '_'
curl -s ${WORKSHOP_URL}${1} |grep "Subscribe to download" |awk -F"<br>" '{print $2}' | awk -F"<" '{print $1}' | tr ' ' '_' | tr '/' '_'
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

fn_populate_modlist_and_dl_mod()
{
cat ${MODSMGT}/modlist.txt | awk -F":" '{print $1" "$2" "$3}'| while read MODNUMBER MODTYPE MODNAME ; do

        #if no type & name, then it's a new mod/miss
        if [ -z "${MODTYPE}" ]; then
                #MOD NOT DL'd, START DOWNLOAD OF THE MOD
                echo "${MODSMGT}/download_mod.sh ${MODNUMBER}"
                ${MODSMGT}/download_mod.sh ${MODNUMBER}
		if [ -d ${WORKSHOP_DIR}/${MODNUMBER} ]; then
	                #GRAB TYPE
			if [ -e ${WORKSHOP_DIR}/${MODNUMBER}/meta.cpp ]; then
                        	MODTYPE="MOD"
	                else
        	                MODTYPE="MIS"
                	fi
	                #GRAB NAME
        	        if [ "${MODTYPE}" == "MOD" ]; then
                	        #GRAB NAME FROM meta.cpp  (ADDS @)
                        	MODNAME="@"$(fn_grab_mod_name_from_metacpp "${MODNUMBER}")
	                elif [ "${MODTYPE}" == "MIS" ]; then
        	                #GRAB NAME AND MAP FROM WEB
                	        MODNAME=$(fn_grab_mission_name_from_web "${MODNUMBER}")
                        	MODNAME2=$(fn_grab_mission_map_from_web "${MODNUMBER}")
	                        MODNAME=$(echo ${MODNAME}"."${MODNAME2}".pbo")
        	        fi
		else 
			echo "MOD/MISSION ${MODNUMBER} not downloaded correctly"
			#exit 102
		fi
        #echo $MODNUMBER; echo $MODTYPE ; echo $MODNAME
        #echo "sed -i 's/${MODNUMBER}/${MODNUMBER}:${MODTYPE}:${MODNAME}/g' ${MODSMGT}/modlist.txt"
                if [ -n "${MODNUMBER}" -a -n "${MODTYPE}" -a -n "${MODNAME}" ]; then
                        sed -i "s,${MODNUMBER},${MODNUMBER}:${MODTYPE}:${MODNAME},g" ${MODSMGT}/modlist.txt
                else
                        echo "Not possible to fetch all the values to fill in the modlist.txt for a new item"
                        #exit 101
                fi
        fi # END OF NEW MODS/MISSIONS

echo $MODNUMBER; echo $MODTYPE ; echo $MODNAME

done
}

fn_create_symlinks()
{
cat ${MODSMGT}/modlist.txt | awk -F":" '{print $1" "$2" "$3}'| while read MODNUMBER MODTYPE MODNAME ; do

        #if no type & name, then something is wrong with it, so we don't mess things up.
        if [ -n "${MODTYPE}" ]; then
                if [ -d ${WORKSHOP_DIR}/${MODNUMBER} ]; then
                        #
                        if [ "${MODTYPE}" == "MOD" ]; then
				if [ ! -L '${MOD_DIR}/@${MODNAME}' ]; then 
					ln -s "${WORKSHOP_DIR}/${MODNUMBER}" "${MOD_DIR}/@${MODNAME}"
				else 
					echo "Link for ${MODTYPE} ${MODNAME} already exists!!!"
				fi
                        elif [ "${MODTYPE}" == "MIS" ]; then
                                if [ ! -L ${MAP_DIR}/${MODNAME} ]; then
#set -x
					find ${WORKSHOP_DIR}/${MODNUMBER} -name '*.bin' -exec ln -s {} "${MAP_DIR}/${MODNAME}"  \;
#set +x
                                else
                                        echo "Link for ${MODTYPE} ${MODNAME} already exists!!!"
                                fi
                        fi
                else
                        echo "ERR!: MOD/MISSION ${MODNUMBER} not downloaded correctly"
                        #exit 102
                fi
	else 
		echo "ERR!: No info on modlist file, so we skip this!"
        fi # END OF NEW MODS/MISSIONS
done

}

fn_tolower()
{
	if [ -n ${WORKSHOP_DIR} ]; then 
		find $WORKSHOP_DIR -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \;
	else 
		echo "Empty values on cfg or variables, nor renaming"
	fi
}

fn_copy_keys()
{
	find ${WORKSHOP_DIR} -type f -name '*.bikey' -exec cp {} ${KEY_DIR}  \;
}
