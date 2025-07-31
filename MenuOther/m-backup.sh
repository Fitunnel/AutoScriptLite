RED="\033[31m"
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
YELL='\033[0;33m'
BGWHITE='\e[0;100;37m'

echo -e ""
echo -e " ${NC} ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
echo -e " ${NC}  ${BGWHITE}               MENU MANAGER BACKUP              ${NC}"
echo -e " ${NC} ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
echo -e " ${NC} ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
echo -e " ${NC}   ${NC}[${GREEN}01${NC}]${YELL}Backup${NC}"
echo -e " ${NC}   ${NC}[${GREEN}02${NC}]${YELL}Restore${NC}"
echo -e " ${NC}   ${NC}[${RED}0X${NC}]${RED}Comeback${NC}"
echo -e " ${NC} ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
echo -e ""
read -p "  Select From Options [ 1-2 / 0X ] »» " opt

case $opt in
01 | 1) clear ; backup ;;
02 | 2) clear ; restore ;;
0 | 00 | x | X | 0x | 0X) clear ; menu ;;
*) clear ; m-backup ;;
esac
