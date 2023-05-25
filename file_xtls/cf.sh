mkdir -p /etc/xray
touch /etc/xray/domain
DOMEN=yha-net.systems
sub=$(</dev/urandom tr -dc a-z0-9 | head -c2)
domain=cloud-${sub}.yha-net.systems
echo "${domain}" > /etc/xray/scdomain
echo "${domain}" > /etc/xray/domain
CF_ID=bhoikfostyahya@gmail.com
CF_KEY=228e06a1b74f8c2e0e38a3855ecb0e70f29c1
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
     
