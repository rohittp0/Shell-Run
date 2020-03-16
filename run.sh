#!/bin/bash
# Reset
Color_Off='\033[0m' # Text Reset

# Regular Colors
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;37m'  # White

# Bold
BBlack='\033[1;30m'  # Black
BRed='\033[1;31m'    # Red
BGreen='\033[1;32m'  # Green
BYellow='\033[1;33m' # Yellow
BBlue='\033[1;34m'   # Blue
BPurple='\033[1;35m' # Purple
BCyan='\033[1;36m'   # Cyan
BWhite='\033[1;37m'  # White

# Underline
UBlack='\033[4;30m'  # Black
URed='\033[4;31m'    # Red
UGreen='\033[4;32m'  # Green
UYellow='\033[4;33m' # Yellow
UBlue='\033[4;34m'   # Blue
UPurple='\033[4;35m' # Purple
UCyan='\033[4;36m'   # Cyan
UWhite='\033[4;37m'  # White

# Background
On_Black='\033[40m'  # Black
On_Red='\033[41m'    # Red
On_Green='\033[42m'  # Green
On_Yellow='\033[43m' # Yellow
On_Blue='\033[44m'   # Blue
On_Purple='\033[45m' # Purple
On_Cyan='\033[46m'   # Cyan
On_White='\033[47m'  # White

# High Intensity
IBlack='\033[0;90m'  # Black
IRed='\033[0;91m'    # Red
IGreen='\033[0;92m'  # Green
IYellow='\033[0;93m' # Yellow
IBlue='\033[0;94m'   # Blue
IPurple='\033[0;95m' # Purple
ICyan='\033[0;96m'   # Cyan
IWhite='\033[0;97m'  # White

# Bold High Intensity
BIBlack='\033[1;90m'  # Black
BIRed='\033[1;91m'    # Red
BIGreen='\033[1;92m'  # Green
BIYellow='\033[1;93m' # Yellow
BIBlue='\033[1;94m'   # Blue
BIPurple='\033[1;95m' # Purple
BICyan='\033[1;96m'   # Cyan
BIWhite='\033[1;97m'  # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'  # Black
On_IRed='\033[0;101m'    # Red
On_IGreen='\033[0;102m'  # Green
On_IYellow='\033[0;103m' # Yellow
On_IBlue='\033[0;104m'   # Blue
On_IPurple='\033[0;105m' # Purple
On_ICyan='\033[0;106m'   # Cyan
On_IWhite='\033[0;107m'  # White

#Templates
Choise="${White}(${BGreen} y${White} / ${BRed}n ${White})${White}"

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
