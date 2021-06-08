#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Writed by ArYa"
TITLE=" Conky Config "
MENU="Choose one of the following options:"
CONKY_PATH=$(which conky)
DISTRO=$(cat /etc/os-release | grep ^ID= | cut --complement -d "=" -f 1)

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
            if [ $CONKY_PATH ]
	    then
		    cp ~/.conkyrc ~/.conkyrc_old
		    cp ./.conkyrc ~
		    conky & 
		    sleep 3
		    echo -e '\n\n'
		    read -p '>>Please press enter to finish...'
		    cp ~/.conkyrc_old ~/.conkyrc
		    rm ~/.conkyrc_old
		    pkill conky
		    clear
		    echo "When you reboot your system all will be like past..."
	    else
		    if [ $DISTRO ]
		    then
			if [ $DISTRO = "ubuntu" ] || [ $DISTRO = "debian" ] || [ $DISTRO = "kali" ]
			then
				echo "installing... "
			elif [ $DISTRO = "arch" ] || [ $DISTRO = "manjaro" ] 
			then
				echo "arch"
			fi
		    fi
	    fi
            ;;
        2)
            echo "You chose Option 2"
            ;;
        3)
            echo "You chose Option 3"
            ;;
esac

