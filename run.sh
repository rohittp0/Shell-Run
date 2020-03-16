#!/bin/bash
source ./colors.sh

cwd=$(pwd)
cd "$(dirname "$(readlink -fm "$0")")"

pword="./password.shadow"
root="/bin/a"
if [ -f "$pword" ]; then
    cat "$pword" | sudo -S -i
else
    echo -e "${BRed}It seems like you don't have sudo password saved."
    echo -e "${BPurple}Enter it now to save it !"
    echo -e "${BCyan}To modify it later change it in ${UCyan}$pword${BCyan} file.${White}"
    read pass
    echo -e $pass | sudo -S touch "$root"
    while ! [ -f "/bin/a" ]; do
        read pass
        echo "$pass" | sudo -S touch "$root"
        echo -e "${BRed}Oops Wrong Password"
        echo -e "${BPurple}Please try again${White}"
    done
    sudo rm "$root"
    echo -e "$pass" >"$pword"
fi

clear

git remote update >>log
HEADHASH=$(git rev-parse HEAD)
UPSTREAMHASH=$(git rev-parse master@{upstream})
clear

if [ "$HEADHASH" != "$UPSTREAMHASH" ]; then
    echo -e "${BGreen}A new version of RunneR is avalable"
    echo -e "${BYellow}Do you want to upgrade ? ${Choise}"
    read -s -n 1 key
    while [[ $key != "n" && $key != "N" ]]; do
        if [[ $key == 'y' || $key == "y" ]]; then
            git pull -v origin master
            break
        else
            echo -e "${BRed}Incorrect Option${White}"
        fi
    done
fi

clear
cd "$cwd"

if [[ $(file --mime-type -b "$1") == "text/x-shellscript" ]]; then
    echo -e "${BYellow}Do you want to run this script ?"
    echo -e "${BPurple}Press enter to run. Any other key to view scource.${White}"
    read -s -n 1 key
    if [[ $key == "" ]]; then
        echo "Starting excecution" >>"$1.log"
        sh "$1" >>"$1.log"
        echo "End of excecution" >>"$1.log"
    else
        gedit "$1"
    fi
elif [[ $(file --mime-type -b "$1") == "text/x-python" ]]; then
    echo -e "${BYellow}Do you want to run this python script ?"
    echo -e "${BPurple}Press enter to run. Any other key to view scource.${White}"
    read -s -n 1 key
    if [[ $key == "" ]]; then
        echo -e "Running script" >>"$1.log"
        python "$1" >>"$1.log"
        echo -e "End of excecution" >>"$1.log"
    else
        gedit "$1"
    fi
else
    echo -e "${BYellow}Are you sure you want to install this package ? ${Choise}"
    read -s -n 1 key
    while [[ true ]]; do
        if [[ $key == "y" || $Key == "Y" ]]; then
            echo -e "Starting installation" >>"$1.log"
            sudo dpkg -i "$1" >>"$1.log"
            echo -e "End of installation" >>"$1.log"
            break
        elif [[ $key == "n" || key == "N" ]]; then
            echo -e "${BRed}Installation Canceled"
            break
        else
            echo -e "${BRed}Incorrect Option${White}"
        fi
    done
fi
echo -e "${White}"
read -s -n 1 key
