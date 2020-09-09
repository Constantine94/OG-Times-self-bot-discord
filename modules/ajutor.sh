discord_WEBHOOK=$(cat config/config.txt | grep "webhook" | sed "s/<webhook>//g")
http POST "$discord_WEBHOOK" content="**C**omanda a fost executata. Asteapta ..."

http POST "$discord_WEBHOOK" \
content='```diff
- Stropii [0.2]

- administrative
accountGenerator
accountTester

- user
verificBan
detaliiActiuni
topMafioti
banuri
topJucatori
waruri
staff
reclamatii
citescReclamatia
topJucatori
infoJucator
cautaJucator
```'