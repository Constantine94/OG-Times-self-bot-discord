discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
discord_adminID=$(cat config/config.txt | grep "admin" | sed "s/<administratorID>//g")

user=$1
echo "$user"
echo "$discord_adminID"

account=$(shuf -n1 modules/conturi.txt)
level=$(echo "$account" | awk '{print $1 $2}')
username=$(echo "$account" | awk '{print $3}')
password=$(echo "$account" | awk '{print $4}')
echo "$level"
echo "$username"
echo "$password"

if [[ "$user" -eq "$discord_adminID" ]];then
	http POST "$discord_WEBHOOK" \
	content=">>> **Conturi** pentru Troll

**Level:** $level
**Username:** $username
**Passwod:** $password"
else
	http POST "$discord_WEBHOOK" \
	content=">>> <@!$user> Nu esti autorizat sa folosesti aceasta comanda "
fi 