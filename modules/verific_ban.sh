discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
censore='s/@\|99999\|99998//g'
user=$1
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."

if [[ $(echo "$user" | grep '<\|>\|&\|%\|~\|/\|*\|#') ]];then
	http POST "$discord_WEBHOOK" \
	content="**C**aractere invalide in nume"
else
	echo "merge"
	if [[ "$(http GET "https://earthpanel.og-times.ro/profile/$user" --headers | grep "HTTP")" =~ "200" ]];then
		http POST "$discord_WEBHOOK" \
		content=">>> **C**ontul exista!"
		echo "merge1"
		scrape_data=$(http GET "https://earthpanel.og-times.ro/profile/$user" | pup ".alert-danger json{}")
		if [[ "$scrape_data" == "[]" ]];then
			http POST "$discord_WEBHOOK" \
			content=">>> **C**ontul nu are ban!"
		else
			banat_de=$(echo "$scrape_data" | jq -r ".[0].children[3].text")
			date=$(echo "$scrape_data" | jq -r ".[0].children[4].text")
			motiv=$(echo "$scrape_data" | jq -r ".[0].children[5].text")

			http POST "$discord_WEBHOOK" \
			content=">>> **Verificare Ban**

**Banat de:** $(echo "$banat_de" | sed $censore)
**Data de:** $(echo "$date" | sed $censore)
**Motivul:** $(echo "$motiv" | sed $censore)"
		fi 
	else
		http POST "$discord_WEBHOOK" \
		content=">>> **C**ontul nu exista!"
	fi
fi
