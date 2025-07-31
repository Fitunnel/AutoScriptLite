#!/bin/bash
MYIP=$(wget -qO- ipv4.icanhazip.com);
echo "Checking VPS"
clear
echo -e ""
echo -e "[ \033[32mInfo\033[0m ] Restart Begin"
sleep 1
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/stunnel4 restart
/etc/init.d/openvpn restart
/etc/init.d/fail2ban restart
/etc/init.d/cron restart
/etc/init.d/nginx restart
/etc/init.d/squid restart
echo -e "[ \033[32mok\033[0m ] Restarting badvpn Service (via systemctl) "
sleep 0.5
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
sleep 0.5
echo -e "[ \033[32mok\033[0m ] Restarting websocket Service (via systemctl) "
sleep 0.5
systemctl restart sshws.service
systemctl restart ws-dropbear.service
systemctl restart ws-stunnel.service
sleep 0.5
echo -e "[ \033[32mInfo\033[0m ] ALL Service Restarted"
echo ""