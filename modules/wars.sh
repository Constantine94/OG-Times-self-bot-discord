censore='s/@\|99999\|99998//g'
discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
scrape_data=$(http GET "https://earthpanel.og-times.ro/wars" | pup ".cd-timeline-content json{}")
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."

dump_data=$(for x in $(echo "$scrape_data" | jq -r ".[0:6][] | @base64");do

	team1=$(echo "$x" | base64 --decode | jq -r ".children[1].children[0].children[0].text")
	team2=$(echo "$x" | base64 --decode | jq -r ".children[1].children[0].children[1].text")
	when=$(echo "$x" | base64 --decode | jq -r ".children[2].text")
	date=$(echo "$x" | base64 --decode | jq -r ".children[3].text")
	echo "$team1"
	echo ":crossed_swords: "
	echo "$team2"
	echo "**Timp:** $when"
	echo "**Cand:** $date"
	echo ""
done)

http POST "$discord_WEBHOOK" \
		content=">>> **Ultimele war-uri **

$dump_data"