#!/bin/bash
# COLOR VALIDATION
clear

# Mendefinisikan warna untuk pesan
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BIRU='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
CYAN_BG='\033[46;1;97m'   # Latar belakang cyan cerah dengan teks putih
LIGHT='\033[0;37m'
PINK='\033[0;35m'
ORANGE='\033[38;5;208m'
PINK_BG='\033[45;1;97m'
BIRU_BG='\033[44;1;97m'
RED_BG='\033[41;1;97m'   # Latar belakang pink cerah dengan teks putih
NC='\033[0m'
INDIGO='\033[38;5;54m'
TEAL='\033[38;5;30m'
WHITE='\033[1;37m'

# Mendapatkan data ISP dan Kota
ISP=$(cat /root/.isp)
CITY=$(cat /root/.city)

if [[ -z $CITY ]]; then
    curl -s ipinfo.io/city > /root/.city
fi

if [[ -z $ISP ]]; then
    curl -s ipinfo.io/org > /root/.isp
fi

# Mendapatkan informasi sistem
IPVPS=$(curl -s ipv4.icanhazip.com)
DOMAIN=$(cat /etc/xray/domain)
RAM=$(free -m | awk 'NR==2 {print $2}')
USAGERAM=$(free -m | awk 'NR==2 {print $3}')
MEMOFREE=$(printf '%-1s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")
LOADCPU=$(printf '%-0.00001s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
MODEL=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
CORE=$(printf '%-1s' "$(grep -c cpu[0-9] /proc/stat)")
DATEVPS=$(date +'%d-%m-%Y')
TIMEZONE=$(printf '%(%H-%M-%S)T')
SERONLINE=$(uptime -p | cut -d " " -f 2-10000)
MYIP=$(curl -sS ipv4.icanhazip.com)

# Validasi IP
IZINSC="https://raw.githubusercontent.com/raffasyaa/permision/main/ea.txt"
USERNAME=$(curl -s ${IZINSC} | grep $MYIP | awk '{print $2}')
VALID=$(curl -s ${IZINSC} | grep $MYIP | awk '{print $3}')
EXP=$VALID

# Status Sertifikat
D1=$(date -d "$VALID" +%s)
D2=$(date -d "$today" +%s)
CERTIFICATE=$(((D1 - D2) / 86400))

# Status Expired atau Active
INFO="(${GREEN}Active${NC})"
ERROR="(${RED}Expired${NC})"
today=$(date -d "0 days" +"%Y-%m-%d")
EXP1=$(curl ${IZINSC} | grep $MYIP | awk '{print $3}')

if [[ $today < $EXP1 ]]; then
    sts="${INFO}"
else
    sts="${ERROR}"
fi

# Layanan yang sedang berjalan
XRAY_VERSION=$(xray -version 2>/dev/null || echo "Xray not installed")
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
dropbear_service=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
haproxy_service=$(systemctl status haproxy | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
xray_service=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nginx_service=$(systemctl status nginx | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

# Tampilan Menu
clear
echo -e " ${TEAL}╭═══════════════════════════════════════════════╮${NC}"
echo -e " ${TEAL}│${NC} ${RED_BG}              SKT AIO PROJECT V1             ${NC} ${TEAL}│${NC}"
echo -e " ${TEAL}╰═══════════════════════════════════════════════╯${NC}"
echo -e " ${TEAL} ═══════════════════════════════════════════════${NC}"
echo -e " ${WHITE}   OS${NC}     : $MODEL"
echo -e " ${WHITE}   RAM${NC}    : $USAGERAM MB / $RAM MB"
echo -e " ${WHITE}   ISP${NC}    : $ISP"
echo -e " ${WHITE}   Domain${NC} : ${TEAL}$DOMAIN${NC}"
echo -e " ${WHITE}   Uptime${NC} : $SERONLINE"
echo -e " ${TEAL} ═══════════════════════════════════════════════${NC}"

# Menu pilihan
echo -e " ${TEAL}╭═══════════════════════════════════════════════╮${NC}"
echo -e " ${TEAL}│${NC} ${BIRU_BG}                   MAIN MENU                 ${NC} ${TEAL}│${NC}"
echo -e " ${TEAL}╰═══════════════════════════════════════════════╯${NC}"
echo -e " ${TEAL} ═══════════════════════════════════════════════${NC}"
echo -e "    [${BIRU}01${NC}]$WHITE MENU SSH & OVPN ${NC}${TEAL}│${NC} [${BIRU}06${NC}]$WHITE FEATURES ${NC}"
echo -e "    [${BIRU}02${NC}]$WHITE MENU XRAY       ${NC}${TEAL}│${NC} [${BIRU}07${NC}]$WHITE SPEEDTEST ${NC}"
echo -e "    [${BIRU}03${NC}]$WHITE MENU TROJAN     ${NC}${TEAL}│${NC} [${BIRU}08${NC}]$WHITE REBUILD VM ${NC}"
echo -e "    [${BIRU}04${NC}]$WHITE MENU SET WARP   ${NC}${TEAL}│${NC} [${BIRU}09${NC}]$WHITE MONITOR CPU ${NC}"
echo -e "    [${BIRU}05${NC}]$WHITE MENU BENCHMARK  ${NC}${TEAL}│${NC} [${BIRU}10${NC}]$WHITE UPDATE SCRIPT ${NC}"
echo -e " ${TEAL} ═══════════════════════════════════════════════${NC}"

# Pilihan pengguna
read -p "  ➣ Your Choice: " opt
echo -e ""
case $opt in
    1)
        echo -e "${TEAL} ➣ Service SSH selected${NC}"
        sktaio-ssh
        ;;
    2)
        echo -e "${TEAL} ➣ Service Xray selected${NC}"
        sktaio-xray
        ;;
    3)
        echo -e "${TEAL} ➣ Service Trojan selected${NC}"
        sktaio-tro
        ;;
    4)
        echo -e "${TEAL} ➣ Service Warp selected${NC}"
        wget -q https://raw.githubusercontent.com/raffasyaa/W4rp/main/warpmenu && bash warpmenu
        ;;
    5)
        echo -e "${TEAL} ➣ Service Benchmark selected${NC}"
        wget -q https://raw.githubusercontent.com/raffasyaa/cekpepes/main/benchmarkmenu && bash benchmarkmenu
        ;;
    6)
        echo -e "${TEAL} ➣ Service Features selected${NC}"
        phreakers-fitur
        ;;
    7)
        echo -e "${TEAL} ➣ Service Check SpeedTest${NC}"
        speedtest 
        ;;
    8)
        echo -e "${TEAL} ➣ Service Rebuild VM selected${NC}"
        wget -q https://raw.githubusercontent.com/raffasyaa/rebuildpepes/main/rebuildpepesmenu && bash rebuildpepesmenu
        ;;
    9)
        echo -e "${TEAL} ➣ Service Monitor CPU selected${NC}"
        gotop
        ;;
    10)
        echo -e "${TEAL} ➣ Service Update Script selected${NC}"
        tr -d '\r' < /usr/local/sbin/skt-update.sh > /tmp/fixed-script && mv /tmp/fixed-script /usr/local/sbin/skt-update.sh && chmod +x /usr/local/sbin/skt-update.sh && tr -d '\r' < /usr/local/sbin/menu > /tmp/fixed-script && mv /tmp/fixed-script /usr/local/sbin/menu && chmod +x /usr/local/sbin/menu && skt-update.sh
        ;;
esac
