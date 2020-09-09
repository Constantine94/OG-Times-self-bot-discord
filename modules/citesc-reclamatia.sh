censore='s/@\|99999\|99998//g'
phpssid=$(cat config/config.txt | grep "phpssid" | sed "s/<phpssid>//g")
discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
faction_id=$1
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."


msg_alert() {

	http POST "$discord_WEBHOOK" \
	content=">>> **E **/stropitoare [verific-reclamatie] [id-ul reclamatiei]"


}

null_complaint() {

	http POST "$discord_WEBHOOK" \
	content=">>> **E **posibil sa fie stearsa sau nu exista reclamatia"


}


last_command=$(http GET "https://earthpanel.og-times.ro/complaint/view/$faction_id" \
'User-Agent: Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.123 Safari/537.36' \
'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
"Cookie: PHPSESSID=$phpssid")


# detalii username 1

celcereclama_username1=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[0].children[0].children[0].children[0].text)
celcereclama_factiune1=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[0].children[1].text)
celcereclama_level1=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[0].children[2].text)
celcereclama_ore1=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[0].children[3].text)
celcereclama_warn1=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[0].children[4].text)
celcereclama_logare1=$(echo "$last_command" | pup '.card-footer json{}' | jq -r .[0].text)

# detalii username 2 

celcereclama_username2=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[1].children[0].children[0].children[0].text)
celcereclama_factiune2=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[1].children[1].text)
celcereclama_level2=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[1].children[2].text)
celcereclama_ore2=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[1].children[3].text)
celcereclama_warn2=$(echo "$last_command" | pup '.media-body json{}' | jq -r .[1].children[4].text)
celcereclama_logare2=$(echo "$last_command" | pup '.card-footer json{}' | jq -r .[1].text)

# status inchisa / deschisa

status=$(echo "$last_command" | pup 'li json{}' | jq -r .[7])

# cand a fost creata 

date=$(echo "$last_command" | pup 'p[data-trigger="hover"] json{}' | jq -r .[0].text)

# dovezi 

dovezi=$(echo "$last_command" | pup 'li p a json{}' | jq -r '.[0].text' | cut -c -100)

detalli=$(echo "$last_command" | pup 'li p json{}' | jq -r '.[3].text' | cut -c -1500)



if [[ $(echo "$faction_id" | grep '<\|>\|&\|%\|~\|/\|*\|#') ]];then
	http POST "$discord_WEBHOOK" \
	content="**C**aractere invalide in nume"
else
	if [[ $faction_id =~ ^[[:digit:]]+$ ]];then
		if [[ $(echo "$faction_id" | wc -m ) -gt 10 ]];then
			null_complaint
		else
			echo "$faction_id"
			echo "$last_command"
			if [[ -z $(echo "$last_command" ) ]];then
				http POST "$discord_WEBHOOK" \
				content=">>> **E**xista reclamatia asta / Sesiunea este setata in config?"
			else
				echo "merge"
				http POST "$discord_WEBHOOK" \
				content=">>> **Complaint Control**

**Impotriva lui:** $celcereclama_username1
$celcereclama_factiune1
$celcereclama_level1
$celcereclama_ore1
$celcereclama_warn1
Status: $celcereclama_logare1

**De catre:** $celcereclama_username2
$celcereclama_factiune2
$celcereclama_level2
$celcereclama_ore2
$celcereclama_warn2
Status: $celcereclama_logare2

$date

**Dovezi: **
$(echo "$dovezi" | sed $censore)
**Detalii**
$(echo "$detalli" | sed $censore)"
			fi

		fi
	else
		null_complaint
	fi
fi 
