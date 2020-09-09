roomid=$(cat setari/setari.txt | grep "room" | sed "s/<roomid>//g")
censore='s/@\|99999\|99998//g'
discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."

get_users=$(http GET "https://earthpanel.og-times.ro/topplayers" | pup "tbody json{}")

dump_data=$(for x in $(echo "$get_users" | jq -r ".[0].children[0:20][] | @base64");do
	loc=$(echo "$x" | base64 --decode | jq -r ".children[0].text")
	username=$(echo "$x" | base64 --decode | jq -r ".children[2].children[0].text")
	level=$(echo "$x" | base64 --decode | jq -r ".children[3].text")
	hours=$(echo "$x" | base64 --decode | jq -r ".children[4].text")
	echo "**Loc:** $loc"
	echo "**Username:** $username"
	echo "**Level:** $level"
	echo "**Hours:** $hours"
	echo ""
done)

http POST "$discord_WEBHOOK" \
content=">>> **Top Jucatori**

$(echo "$dump_data" | sed $censore)"