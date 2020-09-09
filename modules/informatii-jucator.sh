censore='s/@\|99999\|99998//g'
discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."

exista() {

	http POST "$discord_WEBHOOK" \
	content=">>> **C**ontul exista!"
}

nuexista() {

	http POST "$discord_WEBHOOK" \
	content=">>> **C**ontul nu exista!"
}

user=$1
global=$(http GET "https://earthpanel.og-times.ro/profile/$user")

if [[ $(echo "$user" | grep '<\|>\|&\|%\|~\|/\|*\|#') ]];then
	http POST "$discord_WEBHOOK" content="**C**aractere invalide in nume"
else
	echo "merge"
	if [[ "$(http GET "https://earthpanel.og-times.ro/profile/$user" --headers | grep "HTTP")" =~ "200" ]];then
		exista
		# Licente

		licente=$(echo "$global" | pup ".row json{}" )
		lic_drive=$(echo "$licente" | jq -r ".[2].children[1].children[1].children[0].children[1].children[0].children[0].children[1].children[0].children[0].children[0].children[0].children[0].title")
		lic_gun=$(echo "$licente" | jq -r ".[2].children[1].children[1].children[0].children[1].children[0].children[0].children[1].children[0].children[1].children[0].children[0].children[0].title")
		lic_boat=$(echo "$licente" | jq -r ".[2].children[1].children[1].children[0].children[1].children[0].children[0].children[1].children[0].children[2].children[0].children[0].children[0].title")
		lic_fly=$(echo "$licente" | jq -r ".[2].children[1].children[1].children[0].children[1].children[0].children[0].children[1].children[0].children[3].children[0].children[0].children[0].title")

		# Masini
		masini=$(echo "$global" | pup ".table json{}")
		cars=$(for x in $(echo "$masini" | jq -r ".[2].children[1].children[] | @base64 ");do
			cars_name=$(echo "$x" | base64 --decode | jq -r  ".children[1].text" | tr -d [:punct:] | sed "s/ID/ /g" | tr -d "[:digit:]" | tr -d "[:blank:]")
			pret=$(echo "$x" | base64 --decode | jq -r  ".children[2].text")
			km=$(echo "$x" | base64 --decode | jq -r  ".children[3].text")
			culori=$(echo "$x" | base64 --decode | jq -r  ".children[4].text")
			zile=$(echo "$x" | base64 --decode | jq -r  ".children[5].text")
			tag=$(echo "$x" | base64 --decode | jq -r  ".children[6].text")

			echo "**VEH:** $cars_name"
			echo "**PRET:** $pret"
			echo "**KM:** $km"
			echo "**ZILE:** $zile"
			echo ""
		done)

		# Skinuri

		skinuri=$(echo "$global" | pup ".card-block json{}")
		skins=$(for x in $(echo "$skinuri" | jq -r ".[5].children[2:][] | @base64 ");do
			skin_id=$(echo "$x" | base64 --decode | jq -r ".children[0].children[1].children[0].text")
			skin_type=$(echo "$x" | base64 --decode | jq -r ".children[0].children[1].children[1].text")

			echo "**ID:** $skin_id"
			echo "**TIP:** $skin_type"
		done)

		# Case si Bizuri

		case=$(echo "$global" | pup ".card-block json{}")
		check_house=$(echo "$case" | jq -r ".[6].children[0].children[0].children[0].children[1].text")
		check_biz=$(echo "$case" | jq -r ".[7].children[0].children[0].children[0].children[1].text")

		# Factiuni

		factiuni=$(echo "$global" | pup "tbody json{}")
		factions=$(for x in $(echo "$factiuni" | jq -r ".[3].children[0:10][] | @base64 ");do
			reason=$(echo "$x" | base64 --decode | jq -r ".children[1].children[1].text")
			date=$(echo "$x" | base64 --decode | jq -r ".children[2].children[0].children[1].text")
			echo "**Motiv:** $reason"
			echo "**Data:** $date"
			echo ""
		done)

		http POST "$discord_WEBHOOK" \
		content=">>> **Info**
 
 :house: **Casa:** $check_house
 :house_with_garden: **Biz:** $check_biz
 
 :man_pouting: **Skins:**
 $skins
 
 :blue_car: **Licente:**
 **Drive:** $lic_drive
 **Fly:** $lic_fly
 **Boat:** $lic_boat
 **Gun:** $lic_gun"
http POST "$discord_WEBHOOK" \
content=">>> :red_car: **Masini**
$(echo "$cars" | sed "s/null//g")"
http POST "$discord_WEBHOOK" \
content=">>> :police_officer: **Factiuni**
$(echo "$factions" | sed "s/null//g")
**Basic Info**
https://earthpanel.og-times.ro/userbar/$user"
	else 
		nuexista
	fi
fi


	# http POST "$discord_WEBHOOK" content="**C**ontine caractere invalide"
