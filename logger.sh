start() {
	discord_URL=$(cat config/config.txt | grep "discord_url" | sed "s/<discord_url>//g")
	discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
	discord_TOKEN=$(cat config/config.txt | grep "token" | sed "s/<token>//g")


	response=$(

	http GET "$discord_URL" \
	"Authorization: $discord_TOKEN"

	)
	json=$(echo "$response" | jq -r ".[0]")
	discord_username=$(echo "$json" | jq -r ".author.username")
	discord_discriminator=$(echo "$json" | jq -r ".author.discriminator")
	discord_userID=$(echo "$json" | jq -r ".author.id")
	discord_content=$(echo "$json" | jq -r ".content")
	discord_content_argument1=$(echo "$discord_content" | awk '{print $1}') 
	discord_content_argument2=$(echo "$discord_content" | awk '{print $2}') 
	discord_content_argument3=$(echo "$discord_content" | awk '{print $3}') 
	discord_content_argument4=$(echo "$discord_content" | awk '{print $4}') 
	webhook_msg="message to be send"

	send_post_request() {

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

	crack_invalid() {

		webhook_msg="**/**stropitoare crack username password"
		send_post_request "$webhook_msg"
	}

	modul_ajutor() {
		bash modules/ajutor.sh
	}

	modul_staff() {
		bash modules/staff-online.sh
	}

	modul_lista_reclamatii() {
		bash modules/lista_reclamatii.sh
	}

	modul_lista_reclamatii() {
		bash modules/lista_reclamatii.sh
	}

	modul_informatii_jucator() {

		bash modules/informatii-jucator.sh $discord_content_argument3
	}

	modul_cauta_jucator() {

		bash modules/cauta-jucator.sh $discord_content_argument3
	}

	modul_top_jucatori() {

		bash modules/top-jucatori.sh 
	}

	modul_top_jucatori() {

		bash modules/top-jucatori.sh 
	}

	modul_banuri() {

		bash modules/banuri.sh 
	}

	modul_waruri() {

		bash modules/wars.sh 
	}

	modul_jucatoriiSaptamanii() {

		bash modules/jucatorii_saptamanii.sh 
	}

	modul_topMafioti() {

		bash modules/top_mafioti.sh
	}

	modul_detaliiActiuni() {

		bash modules/detaliiActiuni.sh
	}

	modul_ban() {

		bash modules/verific_ban.sh $discord_content_argument3
	}

	modul_verificReclmatie() {

		bash modules/citesc-reclamatia.sh $discord_content_argument3
	}

	modul_generator() {

		bash modules/generator.sh $discord_userID
	}

	modul_tester() {

		bash modules/tester.sh $discord_content_argument3 $discord_content_argument4 
	}

	if [[ "$discord_content_argument1" == "/stropitoare" ]];then
		argument=$discord_content_argument2
		if [[ -z "$discord_content_argument2" ]];then
			webhook_msg="**N**u ai ales o optiune"
			send_post_request "$webhook_msg"
			start
		else
			if [[ ! "$discord_content_argument2" =~ ^[[:alnum:]]+$ ]];then
				invalid_char
				start
			else
				if [[ "$discord_content_argument2" == "asddsa" ]];then
					modul_tester
				elif [[ "$discord_content_argument2" == "help" ]];then
					modul_ajutor
				elif [[ "$discord_content_argument2" == "staff" ]];then
					modul_staff
				elif [[ "$discord_content_argument2" == "reclamatii" ]];then
					modul_lista_reclamatii
				elif [[ "$discord_content_argument2" == "citescReclamatia" ]];then
					modul_verificReclmatie
				elif [[ "$discord_content_argument2" == "infoJucator" ]];then
					modul_informatii_jucator
				elif [[ "$discord_content_argument2" == "cautaJucator" ]];then
					modul_cauta_jucator
				elif [[ "$discord_content_argument2" == "topJucatori" ]];then
					modul_top_jucatori
				elif [[ "$discord_content_argument2" == "banuri" ]];then
					modul_banuri
				elif [[ "$discord_content_argument2" == "waruri" ]];then
					modul_waruri
				elif [[ "$discord_content_argument2" == "topJucatori" ]];then
					modul_jucatoriiSaptamanii
				elif [[ "$discord_content_argument2" == "topMafioti" ]];then
					modul_topMafioti
				elif [[ "$discord_content_argument2" == "detaliiActiuni" ]];then
					modul_detaliiActiuni
				elif [[ "$discord_content_argument2" == "verificBan" ]];then
					modul_ban
				elif [[ "$discord_content_argument2" == "accountGenerator" ]];then
					modul_generator
				elif [[ "$discord_content_argument2" == "accountTester" ]];then
					modul_tester
				else
					webhook_msg="**A**i ales o varianta inexistenta"
					send_post_request "$webhook_msg"
					start
				fi
			fi
		fi
	else 
		:
	fi

}

while true;do
	start
done