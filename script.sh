#!/bin/bash

sudo echo ""
DISTRO=$(cat /etc/os-release | grep ^ID= | cut --complement -d "=" -f 1)
dialog_exist=$(which dialog)
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
                	echo "installing... "
                elif [ $DISTRO = "arch" ] || [ $DISTRO = "manjaro" ] 
                then
                        sudo pacman -Sy conky
                fi
         fi
fi

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Backtitle here"
TITLE="Title here"
MENU="Choose one of the following options:"


OPTIONS=(1 "TEST"
         2 "INSTALL"
         3 "REMOVE")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            cp ~/.conkyrc ~/.conkyrc_old 2>/dev/null
            cp ./.conkyrc ~
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
        3)
	    cp ~/.conkyrc_old ~/.conkyrc 2>/dev/null
            rm ~/.conkyrc_old 2>/dev/null
            pkill conky
	    sed -i '/conky &/d' ~/.profile
	    #chek it please :)
	    ;;

esac

