mkdir -p /etc/xray
touch /etc/xray/domain
DOMEN=warungrio.cloud
sub=$(</dev/urandom tr -dc a-z0-9 | head -c2)
domain=cloud-${sub}.${domen}
echo "${domain}" > /etc/xray/scdomain
echo "${domain}" > /etc/xray/domain
CF_ID=rioanwar29@gmail.com
CF_KEY=zLzRQLFNo4TyRY-WQaMLtfNM_EVI8uDg-z-j3Wk3
set -euo pipefail
IP=$(wget -qO- ipinfo.io/ip);
echo "Updating DNS for ${domain}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMEN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${domain}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${domain}'","content":"'${IP}'","proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${domain}'","content":"'${IP}'","proxied":false}')
     
