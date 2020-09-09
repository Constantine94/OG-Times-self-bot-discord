roomid=$(cat config/config.txt | grep "room" | sed "s/<roomid>//g")
censore='s/@\|99999\|99998//g'
discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
dump_bans=$(http GET "https://earthpanel.og-times.ro/bans" | pup 'tr json{}')
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."

dump_data=$(for x in $(echo "$dump_bans" | jq -r '.[1:6][] | @base64');do

	username=$(echo "$x" | base64 --decode | jq -r ".children[0].children[1].text")
	date=$(echo "$x" | base64 --decode | jq -r ".children[1].text")
	reason=$(echo "$x" | base64 --decode | jq -r ".children[2].text")
	by=$(echo "$x" | base64 --decode | jq -r ".children[3].children[0].text")
	expire=$(echo "$x" | base64 --decode | jq -r ".children[4].text")
	ip=$(echo "$x" | base64 --decode | jq -r ".children[5].text")
	echo "**User:** $username"
	echo "**Date:** $date"
	echo "**Motiv:** $reason"
	echo "**De:** $by"
	echo "**Expira:** $expire"
	echo "**IP:** $ip"
	echo ""

done)

http POST "$discord_WEBHOOK" \
		content=">>> **Bans **

$dump_data"
