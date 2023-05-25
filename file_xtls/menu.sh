#!/bin/bash
clear
# COLOR VALIDATION
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
color3='\e[031;1m'
color2='\e[34;1m'
color3='\e[0m'
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
IPVPS=$(curl -s ipv4.icanhazip.com )
vmess=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vless=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trojan=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
#systm status
if [[ $nginx == "run" ]]; then
   status_nginx="${RED}Not Active${NC}"
else
   status_nginx="${GREEN}Online${NC}"
    fi
if [[ $vmess == "run" ]]; then 
   status_vmess="${RED}Not Active${NC}"
else
   status_vmess=" ${GREEN}Online${NC} "
   fi
if [[ $vless == "run" ]]; then 
   status_vless="${RED}Not Active${NC}"
else
   status_vless=" ${GREEN}Online${NC} "
   fi
if [[ $trojan == "run" ]]; then 
   status_trojan="${RED}Not Active${NC}" 
else
   status_trojan=" ${GREEN}Online${NC} "
   fi  


echo -e "███████████████████████████████████████████████████████████"
echo -e "██▀▄─██▄─██─▄█─▄─▄─█─▄▄─█─▄▄▄▄█─▄▄▄─█▄─▄▄▀█▄─▄█▄─▄▄─█─▄─▄─█"
echo -e "██─▀─███─██─████─███─██─█▄▄▄▄─█─███▀██─▄─▄██─███─▄▄▄███─███"
echo -e "▀▄▄▀▄▄▀▀▄▄▄▄▀▀▀▄▄▄▀▀▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀▄▄▄▀▀▀▀▄▄▄▀▀"
echo -e "███████████████████████ \e[032;1mCPU Model:\e[0m $cname"
echo -e "█▄─▄███▄─▄█─▄─▄─█▄─▄▄─█ \e[032;1mTotal Amount Of RAM:\e[0m $tram MB"
echo -e "██─██▀██─████─████─▄█▀█ \e[032;1mIsp Name:\e[0m $ISP"
echo -e "▀▄▄▄▄▄▀▄▄▄▀▀▄▄▄▀▀▄▄▄▄▄▀ \e[033;1mIPVPS:\e[0m $IPVPS"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e " Vmess Status: $status_vmess  Trojan Status: $status_trojan"
echo -e " VLess Status: $status_vless  Nginx Status: $status_nginx"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e " [${GREEN}1${NC}] ${RED}• ${NC}Creating a Vmess Account $NC"
echo -e " [${GREEN}2${NC}] ${RED}• ${NC}Delete Vmess Account $NC"
echo -e " [${GREEN}3${NC}] ${RED}• ${NC}Renew Vmess Account $NC"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e " [${GREEN}4${NC}] ${RED}• ${NC}Creating a Vless Account $NC"  
echo -e " [${GREEN}5${NC}] ${RED}• ${NC}Delete Vless Account $NC"
echo -e " [${GREEN}6${NC}] ${RED}• ${NC}Renew Vless Account $NC"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e " [${GREEN}7${NC}] ${RED}• ${NC}Creating a Trojan Account  $NC"
echo -e " [${GREEN}8${NC}] ${RED}• ${NC}Delete Trojan Account $NC"  
echo -e " [${GREEN}9${NC}] ${RED}• ${NC}Renew Trojan Account$NC"  
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e " [${GREEN}10${NC}]${RED}• ${NC}Server Speedtest $NC"
echo -e " [${GREEN}11${NC}]${RED}• ${NC}Reboot server $NC"
  read -p "Select From Options [ 1 - 11 ] : " menu
case $menu in
1)
clear
add-ws
;;
2)
clear
del-ws
;;
3)
clear
renew-ws
;;
4)
clear
add-vless
;;
5)
clear
del-vless
;;
6)
clear
renew-vless
;;
7)
clear
add-tr
;;
8)
clear
del-tr
;;
9)
clear
renew-tr
;;
10)
clear
speedtest
;;
11)
reboot
exit
;;
*)
clear
menu
;;
esac
