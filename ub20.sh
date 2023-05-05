#!${local_date}env bash
# //====================================================
# //	System Request:Debian 9+/Ubuntu 18.04+/20+
# //	thx to	bhoikfostyahya
# //	Create by rioxy
# //	©2023-rioxy
# //====================================================

# // font color configuration
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
Font="\033[0m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
OK="${Green}[OKAY]${Font}"
ERROR="${Red}[ERROR]${Font}"

# // configuration GET
IMP="wget -q -O"
local_date="/usr/bin/"
myhost="https://raw.githubusercontent.com/rioxy/xray/main/file_xtls/"
myconf="https://raw.githubusercontent.com/rioxy/xray/main/conf/"
myadd="https://raw.githubusercontent.com/rioxy/xray/main/addons/"
domain="cat /etc/xray/domain"


function print_ok() {
  echo -e "${OK} ${Blue} $1 ${Font}"
}

function print_error() {
  echo -e "${ERROR} ${RedBG} $1 ${Font}"
}

function is_root() {
  if [[ 0 == "$UID" ]]; then
    print_ok "Root user Start installation process"
  else
    print_error "The current user is not the root user, please switch to the root user and run the script again"
    exit 1
  fi
}

judge() {
  if [[ 0 -eq $? ]]; then
    print_ok "$1 Complete... | thx to ${Green}bhoikfostyahya${Font}"
    sleep 1
  else
    print_error "$1 Fail... | thx to ${Green}bhoikfostyahya${Font}"
    exit 1
  fi
}



function domain_add() {
  clear  
  mkdir -p /etc/xray
  touch /etc/xray/domain
  read -rp "Please enter your domain name information(eg: www.example.com):" domain
  domain_ip=$(curl -sm8 ipget.net/?ip="${domain}")
  print_ok "Getting IP address information, please be patient"
  wgcfv4_status=$(curl -s4m8 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
  echo "${domain}" > /etc/xray/scdomain
  echo "${domain}" > /etc/xray/domain
  if [[ ${wgcfv4_status} =~ "on"|"plus" ]]; then
# Close wgcf-warp to prevent misjudgment of VPS IP situation
    wg-quick down wgcf >/dev/null 2>&1
    print_ok "wgcf-warp is turned on"
  fi
  local_ipv4=$(curl -s4m8 https://ip.gs)
  
  echo -e "DNS-resolved IP address of the domain name：${domain_ip}"
  echo -e "Local public network IPv4 address： ${local_ipv4}"
  
  sleep 2
  if [[ ${domain_ip} == "${local_ipv4}" ]]; then
    print_ok "The DNS-resolved IP address of the domain name matches the native IPv4 address"
    sleep 2
  else
    print_error "Please make sure that the correct A/AAAA records are added to the domain name, otherwise xray will not work properly"
    print_error "The IP address of the domain name resolved through DNS does not match the IPv4 address of the machine, continue installed successfully?（y/n）" && read -r install
    case $install in
    [yY][eE][sS] | [yY])
      print_ok "Continue installed successfully"
      sleep 2
      ;;
    *)
      print_error "installed successfully"
      #exit 2
      ;;
    esac
  fi
}


function dependency_install() {
  INS="apt install -y"  
  apt update
  judge "Update configuration"
 
  apt clean all 
  judge "Clean configuration "
  
  ${INS} jq curl
  judge "Installed successfully jq"
  
  ${INS} curl
  judge "Installed successfully unzip"

  ${INS} curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
  judge "Installed socat transport-https"

  ${INS} socat cron bash-completion ntpdate -y
  judge "Installed ntpdate"

  ntpdate pool.ntp.org
  judge "Pool.ntp.org configuration "

  ${INS} net-tools -y
  judge "Installed net-tools"

  ${INS} curl pwgen openssl netcat cron -y
  judge "Installed openssl netcat"

  timedatectl set-timezone Asia/Jakarta
  ${Installed} iptables
  ${Installed} iptables-persistent
}

function download_config() {
${IMP} ${local_date}add-tr "${myhost}add-tr.sh" && chmod +x ${local_date}add-tr
  judge "Installed successfully add trojan account"
${IMP} ${local_date}add-vless "${myhost}add-vless.sh" && chmod +x ${local_date}add-vless
  judge "Installed successfully add vless account"
${IMP} ${local_date}add-ws "${myhost}add-ws.sh" && chmod +x ${local_date}add-ws
  judge "Installed successfully add vmess account"
${IMP} ${local_date}del-tr "${myhost}del-tr.sh" && chmod +x ${local_date}del-tr
  judge "Installed successfully del trojan account"
${IMP} ${local_date}del-vless "${myhost}del-vless.sh" && chmod +x ${local_date}del-vless
  judge "Installed successfully del vless account"
${IMP} ${local_date}del-ws "${myhost}del-ws.sh" && chmod +x ${local_date}del-ws
  judge "Installed successfully del vmess account"
${IMP} ${local_date}renew-tr "${myhost}renew-tr.sh" && chmod +x ${local_date}renew-tr
  judge "Installed successfully renew trojan account"
${IMP} ${local_date}renew-vless "${myhost}renew-vless.sh" && chmod +x ${local_date}renew-vless
  judge "Installed successfully renew vless account"
${IMP} ${local_date}renew-ws "${myhost}renew-ws.sh" && chmod +x ${local_date}renew-ws
  judge "Installed successfully renew vmess account"
${IMP} ${local_date}menu "${myhost}menu.sh" && chmod +x ${local_date}menu
  judge "Installed successfully menu ur dashboard vps"
${IMP} ${local_date}xp "${myhost}xp.sh" && chmod +x ${local_date}xp
  judge "Installed successfully exp all account"
${IMP} ${local_date}speedtest "${myhost}speedtest_cli.py" && chmod +x ${local_date}speedtest
  judge "Installed successfully speedtest"
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

}

function install_xray() {
   domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
   chown www-data.www-data $domainSock_dir
 # // Make Folder Xray & Import link for generating Xray | BHOIKFOST YAHYA AUTOSCRIPT
   judge "Core Xray Version 1.5.8 installed successfully"
   mkdir -p /var/log/xray
   mkdir -p /etc/xray
   chown www-data.www-data /var/log/xray
   chmod +x /var/log/xray
       touch /var/log/xray/access.log
       touch /var/log/xray/error.log
       touch /var/log/xray/access2.log
       touch /var/log/xray/error2.log
   rm -rf /www/xray_web
   mkdir -p /www/xray_web
# //  Xray Core Version new
   bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.5.8
# set uuid
uuid="819e1b6c-9639-4fac-8c3c-d26fad30a447"
# xray config
cat > /etc/xray/config.json << END
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
      {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
   {
     "listen": "127.0.0.1",
     "port": "14016",
     "protocol": "vless",
      "settings": {
          "decryption":"none",
            "clients": [
               {
                 "id": "${uuid}"                 
#vless
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vless"
          }
        }
     },
     {
     "listen": "127.0.0.1",
     "port": "14017",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmess
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vmess"
          }
        }
     },
    {
      "listen": "127.0.0.1",
      "port": "14018",
      "protocol": "trojan",
      "settings": {
          "decryption":"none",		
           "clients": [
              {
                 "password": "${uuid}"
#trojanws
              }
          ],
         "udp": true
       },
       "streamSettings":{
           "network": "ws",
           "wsSettings": {
               "path": "/trojan-ws"
            }
         }
     },
    {
         "listen": "127.0.0.1",
        "port": "30300",
        "protocol": "shadowsocks",
        "settings": {
           "clients": [
           {
           "method": "aes-128-gcm",
          "password": "${uuid}"
#ssws
           }
          ],
          "network": "tcp,udp"
       },
       "streamSettings":{
          "network": "ws",
             "wsSettings": {
               "path": "/ss-ws"
           }
        }
     },	
      {
        "listen": "127.0.0.1",
        "port": "14019",
        "protocol": "vless",
        "settings": {
         "decryption":"none",
           "clients": [
             {
               "id": "${uuid}"
#vlessgrpc
             }
          ]
       },
          "streamSettings":{
             "network": "grpc",
             "grpcSettings": {
                "serviceName": "vless-grpc"
           }
        }
     },
     {
      "listen": "127.0.0.1",
      "port": "14020",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmessgrpc
             }
          ]
       },
       "streamSettings":{
         "network": "grpc",
            "grpcSettings": {
                "serviceName": "vmess-grpc"
          }
        }
     },
     {
        "listen": "127.0.0.1",
        "port": "14021",
        "protocol": "trojan",
        "settings": {
          "decryption":"none",
             "clients": [
               {
                 "password": "${uuid}"
#trojangrpc
               }
           ]
        },
         "streamSettings":{
         "network": "grpc",
           "grpcSettings": {
               "serviceName": "trojan-grpc"
         }
      }
   },
   {
    "listen": "127.0.0.1",
    "port": "30310",
    "protocol": "shadowsocks",
    "settings": {
        "clients": [
          {
             "method": "aes-128-gcm",
             "password": "${uuid}"
#ssgrpc
           }
         ],
           "network": "tcp,udp"
      },
    "streamSettings":{
     "network": "grpc",
        "grpcSettings": {
           "serviceName": "ss-grpc"
          }
       }
    }	
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END
rm -rf /etc/systemd/system/xray.service.d
cat <<EOF> /etc/systemd/system/xray.service
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE                                 AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF
cat > /etc/systemd/system/runn.service <<EOF
[Unit]
Description=BhoikfostYahya
After=network.target

[Service]
Type=simple
ExecStartPre=-${local_date}mkdir -p /var/run/xray
ExecStart=${local_date}chown www-data:www-data /var/run/xray
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF
clear
}





function acme() {
  judge "installed successfully SSL certificate generation script"
  mkdir /root/.acme.sh
  curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
  chmod +x /root/.acme.sh/acme.sh
  /root/.acme.sh/acme.sh --upgrade --auto-upgrade
  /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
  /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
  ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    print_ok "SSL Certificate generated successfully"
}


function nginx_install() {
    print_ok "Nginx Server"
    ${INS} nginx
    judge "Nginx installed successfully"
    rm /etc/nginx/sites-enabled/default
    rm /etc/nginx/sites-available/default
}

function domain_cf() {
    print_ok "enter the domain into the cloudflare dns"
    source <(curl -sL ${myhost}cf.sh)
    judge "domain installed successfully"
}

function configure_nginx() {
#nginx config
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;	
             server_name $domain;
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /var/www/html;
        }
EOF
sed -i '$ ilocation = /vless' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:14016;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /vmess' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:14017;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /trojan-ws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:14018;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /ss-ws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:30300;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation /' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:700;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vless-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:14019;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vmess-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:14020;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /trojan-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:14021;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /ss-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:30310;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

  judge "Nginx configuration modification"
  systemctl daemon-reload
  systemctl enable nginx
  systemctl restart nginx
  systemctl restart xray
  cd
  sleep 5
  reboot
}

function install_addons{
    cd
    source <(curl -sL ${myadd}badvpn/setup.sh)
    print_success "Pemasangan badvpn berhasil"
    sleep 2
    apt install -y iptables && iptables-persistent && sudo
    
sudo iptables -A INPUT -p tcp --dport 433 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 14016 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 14017 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 14018 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 14019 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 14020 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 14021 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 30300 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 30310 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 14016 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 14017 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 14018 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 14019 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 14020 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 14021 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 30300 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 30310 -j ACCEPT
iptables-save > /etc/iptables/rules.v4

    
    
}

function install_sc() {
  domain_add
  dependency_install
  acme
  nginx_install
  install_xray
  download_config
  configure_nginx
  install_addons
}


function install_sc_cf() {
  dependency_install
  domain_cf
  acme
  nginx_install
  install_xray
  download_config
  configure_nginx
  install_addons

}

  # Prevent the default bin directory of some system xray from missing
red='\e[1;31m'
green='\e[0;32m'
tyblue='\e[1;36m'
NC='\e[0m'
echo -e "$green┌─┐┬ ┬┌┬┐┌─┐┌─┐┌─┐┬─┐┬┌─┐┌┬┐  ┬  ┬┌┬┐┌─┐$NC"
echo -e "$green├─┤│ │ │ │ │└─┐│  ├┬┘│├─┘ │   │  │ │ ├┤ $NC"
echo -e "$green┴ ┴└─┘ ┴ └─┘└─┘└─┘┴└─┴┴   ┴   ┴─┘┴ ┴ └─┘$NC"
echo -e "[ ${red}INFO${NC} ] Autoscript xray vpn lite (multi port)"
echo -e "[ ${red}INFO${NC} ] Make sure the internet is smooth when installing the script"
echo -e "${tyblue}[1]${NC}.${green}MANUAL POINTING${NC} ] First connect your VPS IP to the Domain? please click num 1"
echo -e "${tyblue}[2]${NC}.${green}AUTO POINTING${NC} ] do you not have a domain? please click num 2"
  read -rp "CONTINUING TO INSTALL AUTOSCRIPT (1/2)? "  menu_num 
  case $menu_num in
  1)
    install_sc
    ;;
  y)
    install_sc
    ;;
  yes)
    install_sc
    ;;
  2)
    install_sc_cf
    ;;
  n)
    install_sc_cf
    ;;
  not)
    install_sc_cf
    ;;
  back)
    exit
    ;;
  esac
