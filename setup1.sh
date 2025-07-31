#!/bin/bash

# Pastikan skrip dijalankan sebagai root
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    sleep 5
    exit 1
fi

# Periksa virtualisasi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    sleep 5
    exit 1
fi

# Buat direktori dan file yang diperlukan
mkdir -p /etc/xray /etc/v2ray
touch /etc/xray/domain /etc/v2ray/domain /etc/xray/scdomain /etc/v2ray/scdomain

# Perbarui dan instal paket yang diperlukan
apt-get update
apt-get install -y software-properties-common build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git dos2unix

# Unduh dan instal Python 2.7 dari sumber
cd /usr/src
wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar xzf Python-2.7.18.tgz
cd Python-2.7.18
./configure --enable-optimizations
make altinstall

# Pastikan python2.7 adalah perintah untuk Python 2.7
update-alternatives --install /usr/bin/python python /usr/local/bin/python2.7 1
update-alternatives --set python /usr/local/bin/python2.7

# Periksa apakah perintah 'python' berfungsi dan mengarah ke Python 2.7
if ! python --version 2>&1 | grep -q "Python 2.7"; then
    echo "Failed to set python to Python 2.7"
    exit 1
fi

# Domain configuration
echo "1. Gunakan Domain Acak Kami"
echo "2. Pilih Domain Anda Sendiri"
read -rp "Input 1 or 2: " dns
if [ "$dns" -eq 1 ]; then
    # Download cf script and convert line endings
    wget https://raw.githubusercontent.com/Fitunnel/AutoScriptLite/main/InstallerOther/cf
    dos2unix cf
    bash cf
elif [ "$dns" -eq 2 ]; then
    read -rp "Masukkan Domain Anda: " dom
    echo "$dom" > /var/lib/ipvps.conf
    echo "$dom" > /root/scdomain
    echo "$dom" > /etc/xray/scdomain
    echo "$dom" > /etc/xray/domain
    echo "$dom" > /etc/v2ray/domain
    echo "$dom" > /root/domain
else
    echo "Not Found Argument"
    exit 1
fi

# Install services SSH
wget -q https://raw.githubusercontent.com/Fitunnel/AutoScriptLite/main/InstallerSSH/ssh-vpn.sh
dos2unix ssh-vpn.sh
bash ssh-vpn.sh

# Setup environment for auto-reboot
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

# Log setup
mkdir -p /var/lib/
echo "IP=" >> /var/lib/ipvps.conf

# Installation summary
echo "Services and Ports:"
echo " - OpenSSH: 22"
echo " - SSH Websocket: 80"
echo " - SSH SSL Websocket: 443"
echo " - Stunnel4: 222, 777"
echo " - Dropbear: 109, 143"
echo " - Badvpn: 7100-7900"
echo " - Nginx: 81"

# Additional commands SSH
# Stop systemd-resolved service
sudo systemctl stop systemd-resolved
# Disable systemd-resolved from starting at boot
sudo systemctl disable systemd-resolved
cp /etc/resolv.conf resolv.bak
# Remove the existing symlinked resolv.conf
sudo rm /etc/resolv.conf
# Create a new resolv.conf file with custom DNS entries
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" | sudo tee /etc/resolv.conf > /dev/null
echo "systemd-resolved is disabled, and a new resolv.conf has been created."

sudo tee /etc/default/dropbear >/dev/null <<EOF
# disabled because OpenSSH is installed
# change to NO_START=0 to enable Dropbear
NO_START=0
# the TCP port that Dropbear listens on
DROPBEAR_PORT=69
# any additional arguments for Dropbear
DROPBEAR_EXTRA_ARGS="-p 109"
# specify an optional banner file containing a message to be
# sent to clients before they connect, such as "/etc/issue.net"
DROPBEAR_BANNER="/etc/issue.net"
# RSA hostkey file (default: /etc/dropbear/dropbear_rsa_host_key)
#DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
# DSS hostkey file (default: /etc/dropbear/dropbear_dss_host_key)
#DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
# ECDSA hostkey file (default: /etc/dropbear/dropbear_ecdsa_host_key)
#DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
# Receive window size - this is a tradeoff between memory and
# network performance
DROPBEAR_RECEIVE_WINDOW=65536
EOF

# Set the banner file path
DROPBEAR_BANNER="/etc/issue.net"
# Correct Dropbear service unit file with the banner
cat <<EOF > /usr/lib/systemd/system/dropbear.service
[Unit]
Description=Lightweight SSH server
Documentation=man:dropbear(8)
After=network.target
[Service]
Environment=DROPBEAR_PORT=22 DROPBEAR_RECEIVE_WINDOW=65536 DROPBEAR_BANNER="$DROPBEAR_BANNER"
EnvironmentFile=-/etc/default/dropbear
ExecStart=/usr/sbin/dropbear -EF -p "\$DROPBEAR_PORT" -W "\$DROPBEAR_RECEIVE_WINDOW" -b "\$DROPBEAR_BANNER"
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
# Reload systemd daemon
sudo systemctl daemon-reload
# Restart Dropbear service
sudo systemctl restart dropbear.service
sudo systemctl start dropbear
sudo systemctl enable dropbear

# Define swap file size and location
SWAPFILE=/swapfile
SWAPSIZE=2G
# Create a swap file
sudo fallocate -l $SWAPSIZE $SWAPFILE
# Set the correct permissions
sudo chmod 600 $SWAPFILE
# Set up a Linux swap area
sudo mkswap $SWAPFILE
# Enable the swap file
sudo swapon $SWAPFILE
# Make the swap file permanent
echo "$SWAPFILE none swap sw 0 0" | sudo tee -a /etc/fstab
# Verify the swap is active
sudo swapon --show
# Display the current swap usage
free -h

#Install Backup VPS
REPO="https://raw.githubusercontent.com/Fitunnel/AutoScriptLite/main/InstallerOthers/"
apt install rclone -y
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "${REPO}rclone.conf"
#Install Wondershaper
cd /bin
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
sudo make install
cd
rm -rf wondershaper
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y
cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
account default
host smtp.gmail.com
port 587
auth on
user oceantestdigital@gmail.com
from oceantestdigital@gmail.com
password jokerman77 
logfile ~/.msmtp.log
EOF
chown -R www-data:www-data /etc/msmtprc

# Cleanup and reboot
rm -f /root/setup.sh /root/insshws.sh cf ssh-vpn.sh insshws.sh
echo "Auto reboot in 10 seconds..."
sleep 10

# Reboot
reboot
