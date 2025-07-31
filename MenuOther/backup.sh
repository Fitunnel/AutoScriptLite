IP=$(curl -sS ipv4.icanhazip.com)
domain=$(cat /etc/xray/domain)
date=$(date +"%Y-%m-%d")
clear
email=$(cat /root/email)
if [[ "$email" = "" ]]; then
clear
echo "Masukkan Email Untuk Menerima Backup"
echo -e ""
echo -e "\033[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/user-create/user.log
read -rp "Input Your Email : " -e email
echo -e "\033[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/user-create/user.log
cat <<EOF>>/root/email
$email
EOF
fi
clear
echo -e "\033[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/user-create/user.log
echo -e "\033[1;92mWait Backup Procces.......\033[0m"
echo -e "\033[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/user-create/user.log
rm -rf /root/backup
mkdir /root/backup
cp /etc/passwd /root/backup/
cp /etc/group /root/backup/
cp -r /var/www/html/ /root/backup/html
cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip dr:backup/
url=$(rclone link dr:backup/$IP-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
echo -e "
Detail Backup 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
IP VPS        : $IP
Link Backup   : $link
Tanggal       : $date
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
" | mail -s "Backup Data" $email
rm -rf /root/backup
rm -r /root/$IP-$date.zip
clear
echo -e "
Detail Backup 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
IP VPS        : $IP
Link Backup   : $link
Tanggal       : $date
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
echo "Silahkan copy Link dan restore di VPS baru"
echo ""