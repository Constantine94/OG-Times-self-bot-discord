censore='s/@\|99999\|99998//g'
discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
user=$1
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."

if [[ $(echo "$user" | grep '<\|>\|&\|%\|~\|/\|*\|#') ]];then
	http POST "$discord_WEBHOOK" \
	content="**C**aractere invalide in nume"
else
	get_users=$(http POST "https://earthpanel.og-times.ro/search?name=$user" \
	'Connection: close' \
	'Accept: application/json, text/javascript, */*; q=0.01' \
	'X-Requested-With: XMLHttpRequest' \
	'User-Agent: Mozilla/5.0 (Windows NT 6.2; Win64; rv:67.0) Gecko/20100101 Firefox/67.0' \
	'Referer: https://earthpanel.og-times.ro/' \
	'Accept-Encoding: gzip, deflate' \
	'Accept-Language: en-US,en;q=0.9')

	dump_data=$(for x in $(echo "$get_users " | jq -r ".[] | @base64");do
		users=$(echo $x | base64 --decode | jq -r ".nickname")
		users_level=$(echo $x | base64 --decode | jq -r ".level")
		echo "**User:** $users" | sed $censore
		echo "**Level:** $users_level" | sed $censore
		echo ""
	done)

	http POST "$discord_WEBHOOK" \
	content=">>> **Users**

$(echo "$dump_data" | tail -c 1500)"
fi