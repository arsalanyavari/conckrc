#!/bin/bash

sudo echo ""
DISTRO=$(cat /etc/os-release | grep ^ID= | cut --complement -d "=" -f 1)
dialog_exist=$(which dialog)
dialogrc_path=$(ls ~/.dialogrc 2> /dev/null)
CONKY_PATH=$(which conky)
LIST_OF_NETWORK_INTERFACES=(`ip addr show | grep "^[0-9]" | cut -d ":" -f 2`)

sudo mkdir ~/.conky 2> /dev/null
if [ -z "$dialog_exist" ]
then
	if [ $DISTRO = "ubuntu" ] || [ $DISTRO = "debian" ] || [ $DISTRO = "kali" ]
	then
		sudo apt install dialog -y
	elif [ $DISTRO = "arch" ] || [ $DISTRO = "manjaro" ]
	then
        	sudo pacman -Sy dialog
	elif [ $DISTRO = "fedora" ] || [ $DISTO = "centos" ] || [ $DISTRO = "opensuse" ]
	then
		sudo dnf -y dialog
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
		elif [ $DISTRO = "fedora" ] || [ $DISTO = "centos" ] || [ $DISTRO = "opensuse" ]
		then
			sudo dnf -y conky
                fi
         fi
fi

sudo cp ~/.dialogrc ~/.dialogrc_old 2> /dev/null
sudo cp ./.dialogrc ~/

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Dedicated to X.rmz"
TITLE="Conky Installer"
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

case $CHOICE in
        1)
            sudo cp ~/.conkyrc ~/.conkyrc_old 2> /dev/null
            sudo cp ./.conkyrc ~/
            sudo cp -r ./pic ~/.conky/
            conky & 
            sleep 3
            echo -e '\n\n'
            read -p '>>Please press ENTER to finish...'
            sudo rm ~/.conkyrc
            sudo cp ~/.conkyrc_old ~/.conkyrc 2> /dev/null
            sudo rm -r ~/.conky/pic
            pkill conky
            clear
            echo "When you reboot your system all will be like past..."
            ;;
        2)
	    #dialog --backtitle "Processor Selection" --radiolist "Select Processor type:" 10 40 4 1 Pentium off 2 Athlon on 3 Celeron off 4 Cyrix off ========> selecting network interface
            sudo cp ~/.conkyrc ~/.conkyrc_old 2> /dev/null
            sudo cp ./.conkyrc ~/
            sudo cp -r ./pic ~/.conky/
            sed -i '/conky &/d' ~/.profile
            echo "conky &" >> ~/.profile
            echo "successfull! please reboot your system =)"
            ;;
        3)
            sudo rm ~/.conkyrc 2> /dev/null
            sudo mv ~/.conkyrc_old ~/.conkyrc 2> /dev/null
            sudo rm -r ~/.conky/pic 2> /dev/null
            pkill conky
            sed -i '/conky &/d' ~/.profile
            ;;

esac

if [ -z "$dialogrc_path" ]
then
        sudo rm ~/.dialogrc
else
        sudo cp ~/.dialogrc_old ~/.dialogrc
fi




