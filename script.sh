#!/bin/bash

sudo echo ""
DISTRO=$(cat /etc/os-release | grep ^ID= | cut --complement -d "=" -f 1)
dialog_exist=$(which dialog)
dialogrc_path=$(ls ~/.dialogrc 2> /dev/null)
CONKY_PATH=$(which conky)
sudo mkdir ~/.conky
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

sudo cp ~/.dialogrc ~/.dialogrc_old 2> /dev/null
sudo cp ./.dialogrc ~/

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
		--colors \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

if [ -z "$dialogrc_path" ]
then
        sudo rm ~/.dialogrc
else
        sudo cp ~/.dialogrc_old ~/.dialogrc
fi

case $CHOICE in
        1)
            sudo cp ~/.conkyrc ~/.conkyrc_old 2>/dev/null
            sudo cp ./.conkyrc ~/
            sudo cp -r ./pic ~/.conky/
            conky & 
            sleep 3
            echo -e '\n\n'
            read -p '>>Please press enter to finish...'
            sudo rm ~/.conkyrc
            sudo cp ~/.conkyrc_old ~/.conkyrc 2>/dev/null
            sudo rm -r ~/.conky/pic
            pkill conky
            clear
            echo "When you reboot your system all will be like past..."
            ;;
        2)
            sudo cp ~/.conkyrc ~/.conkyrc_old 2>/dev/null
            sudo cp ./.conkyrc ~/
            sudo cp -r ./pic ~/.conky/
            sed -i '/conky &/d' ~/.profile
            echo "conky &" >> ~/.profile
            echo "successfull! please reboot your system =)"
            ;;
        3)
            sudo rm ~/.conkyrc
            sudo mv ~/.conkyrc_old ~/.conkyrc 2>/dev/null
            sudo rm -r ~/.conky/pic
            pkill conky
            sed -i '/conky &/d' ~/.profile
            ;;

esac
