censore='s/@\|99999\|99998//g'
discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
scrape_data=$(http GET "https://earthpanel.og-times.ro/" | pup "table json{}")
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."

dump_data=$(for x in $(echo "$scrape_data" | jq -r ".[0].children[1].children[0:6][] | @base64");do

	username=$(echo $x | base64 --decode | jq -r '.children[1].children[0].children[0].text')
	reason=$(echo $x | base64 --decode | jq -r '.children[1].children[1].text')
	time=$(echo $x | base64 --decode | jq -r '.children[2].children[0].text')

	echo "**Username:** $username" | sed $censore
	echo "**Time:** $time"
	echo "**Reason:** $reason" | sed $censore
	echo ""

done)


http POST "$discord_WEBHOOK" \
		content=">>> **Ultimele actiuni **

$dump_data"