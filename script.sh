#!/bin/bash

sudo echo ""
DISTRO=$(cat /etc/os-release | grep ^ID= | cut --complement -d "=" -f 1)
dialog_exist=$(which dialog)
dialogrc_path=$(ls ~/.dialogrc 2> /dev/null)
CONKY_PATH=$(which conky)
if [ -z "$dialog_exist" ]
then
	if [ $DISTRO = "ubuntu" ] || [ $DISTRO = "debian" ] || [ $DISTRO = "kali" ]
	then
		sudo apt install dialog -y
	elif [ $DISTRO = "arch" ] || [ $DISTRO = "manjaro" ]
	then
        	sudo pacman -Sy dialog
	fi
fi
if [ -z "$CONKY_PATH" ]
then
	if [ $DISTRO ]
        then
        	if [ $DISTRO = "ubuntu" ] || [ $DISTRO = "debian" ] || [ $DISTRO = "kali" ]
                then
                	sudo apt install conky -y
                elif [ $DISTRO = "arch" ] || [ $DISTRO = "manjaro" ] 
                then
                        sudo pacman -Sy conky
                fi
         fi
fi

cp ~/.dialogrc ~/.dialogrc_old 2> /dev/null
cp ./.dialogrc ~/

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="dedicated to X.RMZ"
TITLE=" \Zb\Z1ARYA\Z3 concky configure "
MENU="Choose one of the following options:"


OPTIONS=(1 "TEST"
         2 "INSTALL"
         3 "REMOVE")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
		--colors \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

if [ -z "$dialogrc_path" ]
then
	rm ~/.dialogrc
else
	cp ~/.dialogrc_old ~/.dialogrc
fi

case $CHOICE in
        1)
            cp ~/.conkyrc ~/.conkyrc_old 2>/dev/null
            cp ./.conkyrc ~/  
            conky & 
            sleep 3
  	    echo -e '\n\n'
	    read -p '>>Please press enter to finish...'
            cp ~/.conkyrc_old ~/.conkyrc 2>/dev/null
            rm ~/.conkyrc_old
            pkill conky
            clear
            echo "When you reboot your system all will be like past..."
            ;;
        2)
	    cp ~/.conkyrc ~/.conkyrc_old 2>/dev/null
            cp ./.conkyrc ~ 2>/dev/null
	    sed -i '/conky &/d' ~/.profile
	    echo "conky &" >> ~/.profile
	    echo "successfull! please reboot your sestem"
            ;;
        3)<
	    rm ~/.conkyrc
            mv ~/.conkyrc_old ~/.conkyrc 2>/dev/null
            pkill conky
	    sed -i '/conky &/d' ~/.profile
	    ;;

esac
