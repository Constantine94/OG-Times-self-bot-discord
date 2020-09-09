discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."
get_users=$(http GET "https://earthpanel.og-times.ro/staff" | pup "tbody json{}")
admini_online=$(echo "$get_users" | jq -r '.[0].children[] | select(.children[].children[0].text == "online")' | jq -r ".children[2].children[0].children[0].children[].text")
helperi_online=$(echo "$get_users" | jq -r '.[1].children[] | select(.children[].children[0].text == "online")' | jq -r ".children[2].children[0].children[0].children[].text")
lideri_online=$(echo "$get_users" | jq -r '.[2].children[] | select(.children[].children[0].text == "online")' | jq -r ".children[2].children[0].children[0].children[].text")

http POST "$discord_WEBHOOK" \
content=">>> **Admini online**

$(echo "$admini_online" | sed "s/pula/cesored/g")

**Helperi online**

$(echo "$helperi_online" | sed "s/pula/cesored/g")

**Lideri Online**

$(echo "$lideri_online" | sed "s/pula/cesored/g")
"