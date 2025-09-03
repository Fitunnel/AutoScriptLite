<p align="center">  
    <img src="https://user-images.githubusercontent.com/76937659/153705486-44e6c1b2-74fa-4d44-be1c-36c8fdb83331.gif"/>  
  </p>  
  
   <p align="center"> 
                SSH ONLY
   </p>
  
  <p align="center">  
    <img src="https://user-images.githubusercontent.com/76937659/153705486-44e6c1b2-74fa-4d44-be1c-36c8fdb83331.gif"/>  
  </p> 
  
<b><details><summary>INSTALL</summary></b>
***Ubuntu/Debian***

***TAHAP 1***
``` 
apt update && apt upgrade
```
***TAHAP 2***
```
wget -q https://raw.githubusercontent.com/Fitunnel/AutoScriptLite/main/setup.sh && chmod +x setup.sh && ./setup.sh
```
</details>

<b><details><summary>Service & Port</summary></b> 
 <p align="center"> 
<img src="https://img.shields.io/badge/-Services%20%26%20Port-brightgreen"> 
  
```
» Open SSH                   : 80, 22
» Dropbear                   : 443, 109, 143
» Dropbear Websocket         : 443, 109
» SSH Websocket SSL          : 443
» SSH Websocket              : 80
» SSH UDP                    : 1-65535
» OpenVPN SSL                : 443
» OpenVPN Websocket SSL      : 443
» OpenVPN TCP                : 443, 1194
» OpenVPN UDP                : 2200
» Nginx Webserver            : 443, 80, 81
» Haproxy Loadbalancer       : 443, 80
» DNS Server                 : 443, 53
» DNS Client                 : 443, 88
» OpenVPN Websocket SSL      : 443
» BadVPN 1                   : 7100
» BadVPN 2                   : 7200
» BadVPN 3                   : 7300
```
</details>

<b><details><summary>Fix Auto Expired Account</summary></b> 
 <p align="center"> 
  
```
Cara Fix Auto Expired SSH :
1. Cari Di Folder Root/etc/cron.d xp_all
2. Edit ke :
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
15 0 * * * root /usr/local/sbin/xp
3. Terus Di Folder Root/etc/hosts edit ke :
127.0.0.1 localhost
127.0.0.1 Dev-Alfi (Dev-Alfi ganti Hostname Kalian)

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
4. Sesudah itu kita cek dengan menggunakan printah :
sudo grep "unable to resolve host" /var/log/syslog
5. Gunakan Perintah 'sudo crontab -e'
6. lalu tambahkan teks di bawah ini :
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
15 0 * * * root /usr/local/sbin/xp
7. Tekan Ctrl + X kemudian Y dan enter
8.kita cek gunakan printah ini :
sudo grep CRON /var/log/syslog (Memeriksa Log)
sudo systemctl status cron (Cek Status RUNNING)
```
</details>
