discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
censore='s/@\|99999\|99998//g'
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."

scrape_data=$(http GET "https://earthpanel.og-times.ro/topgangsters" | pup "tbody json{}")

dump_data=$(for x in $(echo "$scrape_data" | jq -r ".[].children[0:20][] | @base64");do
	username=$(echo "$x" | base64 --decode | jq -r ".children[2].children[0].text")
	kills=$(echo "$x" | base64 --decode | jq -r ".children[3].text")
	echo "**User:**  $username"
	echo "**Kills:** [ $kills ] "
	echo ""
done)

http POST "$discord_WEBHOOK" \
		content=">>> **Top codati **

$(echo "$dump_data" | sed $censore )"