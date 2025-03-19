#!/bin/bash
REPO="https://raw.githubusercontent.com/rosi606/T4NN3L/main/"
wget -q -O /etc/systemd/system/limitvmess.service "${REPO}SKT-Tools/limitvmess.service" && chmod +x limitvmess.service >/dev/null 2>&1
wget -q -O /etc/systemd/system/limitvless.service "${REPO}SKT-Tools/limitvless.service" && chmod +x limitvless.service >/dev/null 2>&1
wget -q -O /etc/systemd/system/limittrojan.service "${REPO}SKT-Tools/limittrojan.service" && chmod +x limittrojan.service >/dev/null 2>&1
wget -q -O /etc/systemd/system/limitshadowsocks.service "${REPO}SKT-Tools/limitshadowsocks.service" && chmod +x limitshadowsocks.service >/dev/null 2>&1
wget -q -O /etc/xray/limit.vmess "${REPO}SKT-Tools/vmess" >/dev/null 2>&1
wget -q -O /etc/xray/limit.vless "${REPO}SKT-Tools/vless" >/dev/null 2>&1
wget -q -O /etc/xray/limit.trojan "${REPO}SKT-Tools/trojan" >/dev/null 2>&1
wget -q -O /etc/xray/limit.shadowsocks "${REPO}SKT-Tools/shadowsocks" >/dev/null 2>&1
chmod +x /etc/xray/limit.vmess
chmod +x /etc/xray/limit.vless
chmod +x /etc/xray/limit.trojan
chmod +x /etc/xray/limit.shadowsocks
systemctl daemon-reload
systemctl enable --now limitvmess
systemctl enable --now limitvless
systemctl enable --now limittrojan
systemctl enable --now limitshadowsocks
systemctl start limitvmess
systemctl start limitvless
systemctl start limittrojan
systemctl start limitshadowsocks
systemctl restart limitvmess
systemctl restart limitvless
systemctl restart limittrojan
systemctl restart limitshadowsocks