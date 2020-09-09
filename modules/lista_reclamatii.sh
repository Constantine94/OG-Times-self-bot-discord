
discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
censore='s/@\|99999\|99998//g'
phpssid=$(cat config/config.txt | grep "phpssid" | sed "s/<phpssid>//g")

http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."


scrape_data=$(http GET "https://earthpanel.og-times.ro/complaints" \
'User-Agent: Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.123 Safari/537.36' \
'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
"Cookie: PHPSESSID=$phpssid" | pup 'tbody json{}')


dump_data=$(for x in $(echo "$scrape_data" | jq -r ".[0].children[0:10][] | @base64");do
motiv=$(echo "$x" | base64 --decode | jq -r ".children[0].text")
creator=$(echo "$x" | base64 --decode | jq -r ".children[2].children[0].children[0].children[1].text")
impotriva=$(echo "$x" | base64 --decode | jq -r ".children[1].children[0].children[0].children[1].text")
date=$(echo "$x" | base64 --decode | jq -r ".children[3].children[0].text")
status=$(echo "$x" | base64 --decode | jq -r ".children[4].children[0].children[0].text")
id=$(echo "$x" | base64 --decode | jq -r ".children[5].children[0].onclick" | cut -c 35- | sed s/"&#39;"//g)
echo "**Motiv:** $motiv" | sed "$censore"
echo "**Creator:** $creator" | sed "$censore"
echo "**Impotriva:** $impotriva" | sed "$censore"
echo "**Data:** $date"
echo "**Status:** $status"
echo "**ID:** $id"
echo ""
done)

echo "$dump_data"

http POST "$discord_WEBHOOK" \
content=">>> **Lista reclamatii**

$dump_data"