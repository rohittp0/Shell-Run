#!/bin/bash
./colors.sh

cwd=$(pwd)
cd "$(dirname "$(readlink -fm "$0")")"

pword="./password.shadow"
root="/bin/a"
printf "\n\n"

if [ -f "$pword" ]; then
    cat "$pword" | sudo -S -i
else
    printf "${BRed}It seems like you don't have sudo password saved.\n"
    printf "${BPurple}Enter it now to save it !\n"
    printf "${BCyan}To modify it later change it in ${UCyan}$pword${BCyan} file.${White}\n"
    read pass
    printf $pass | sudo -S touch "$root"
    while ! [ -f "/bin/a" ]; do
        read pass
        echo "$pass" | sudo -S touch "$root"
        printf "${BRed}Oops Wrong Password\n"
        printf "${BPurple}Please try again${White}\n"
    done
    sudo rm "$root"
    printf "$pass" >"$pword"
fi

clear
printf "\n\n"

git remote update
HEADHASH=$(git rev-parse HEAD)
UPSTREAMHASH=$(git rev-parse master@{upstream})

clear
printf "\n\n"

if [ "$HEADHASH" != "$UPSTREAMHASH" ]; then
    printf "${BGreen}A new version of RunneR is avalable\n"
    printf "${BYellow}Do you want to upgrade ? ${Choise}\n"
    read -s -n 1 key
    while [[ $key != "n" && $key != "N" ]]; do
        if [[ $key == 'y' || $key == "y" ]]; then
            git pull -v origin master
            printf "${BPurple}Press enter to continue.${White}\n"
            read -s -n 1 a
            break
        else
            printf "${BRed}Incorrect Option${White}\n"
        fi
    done
fi

cd "$cwd"
clear
printf "\n\n"

if [[ $(file --mime-type -b "$1") == "text/x-shellscript" ]]; then
    printf "${BYellow}Do you want to run this script ?\n"
    printf "${BPurple}Press enter to run. Any other key to view scource.${White}\n"
    read -s -n 1 key
    if [[ $key == "" ]]; then
        echo "Starting excecution" >>"$1.log"
        sh "$1" >>"$1.log"
        echo "End of excecution" >>"$1.log"
    else
        gedit "$1"
    fi
elif [[ $(file --mime-type -b "$1") == "text/x-python" ]]; then
    printf "${BYellow}Do you want to run this python script ?\n"
    printf "${BPurple}Press enter to run. Any other key to view scource.${White}\n"
    read -s -n 1 key
    if [[ $key == "" ]]; then
        echo "Running script" >>"$1.log"
        python "$1" >>"$1.log"
        echo "End of excecution" >>"$1.log"
    else
        gedit "$1"
    fi
else
    printf "${BYellow}Are you sure you want to install this package ? ${Choise}\n"
    read -s -n 1 key
    while [[ true ]]; do
        if [[ $key == "y" || $Key == "Y" ]]; then
            echo "Starting installation" >>"$1.log"
            sudo dpkg -i "$1" >>"$1.log"
            echo "End of installation" >>"$1.log"
            break
        elif [[ $key == "n" || key == "N" ]]; then
            printf "${BRed}Installation Canceled\n"
            break
        else
            printf "${BRed}Incorrect Option${White}\n"
        fi
    done
fi

printf "${BPurple}Press enter to continue.${White}\n"
read -s -n 1 key
