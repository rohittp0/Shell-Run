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

pword="./.password.shadow"
root="/bin/a"
version="https://raw.githubusercontent.com/rohittp0/Shell-Run/master/.version"
ran=false
choise=false
printf "\n\n"

function getChoise() {
    read -s -n 1 key
    while [[ true ]]; do
        if [[ $key == "y" || $Key == "Y" ]]; then
            choise=true
            break
        elif [[ $key == "n" || key == "N" ]]; then
            choise=false
            break
        else
            printf "${BRed}Incorrect Option${White}\n"
            read -s -n 1 key
        fi
    done
}

function getTextEditor() {
    declare -a editors=("VSCode(c)" "Gedit(g)" "Nano(n)" "Vim(v)" "Cat(t)")
    declare -a options=("c" "g" "n" "v" "t" "C" "G" "N" "V" "T")
    declare -a command=("code" "gedit" "nano" "vi" "cat")
    printf "${BPurple}Choose which text editor you want to use ?\n"
    printf "Your options are : \n\n${BCyan}"
    for ((i = 0; i < ${#editors[@]}; i++)); do
        printf "${editors[$i]} "
    done
    printf "${BPurple}\n\nEnter # to exit${BWhite}\n\t"
    read -s -n 1 key
    while [[ $key != '#' ]]; do
        for ((i = 0; i < ${#options[@]}; i++)); do
            if [[ $key == ${options[$i]} ]]; then
                printf "Opening file... \n${Color_Off}"
                "${command[$(expr $i % ${#command[@]})]}" "$1"
                break 2
            fi
        done
        printf "${BRed}Incorrect Option${White}\n"
        read -s -n 1 key
    done
}

function runFile() {
    case $2 in
    0) chmod +x "$1" && bash "$1" ;;
    1) gcc "$1" -o /tmp/$(basename "$1") && chmod +x /tmp/$(basename "$1") && /tmp/$(basename "$1") ;;
    2) java -jar "$1" ;;
    3) python "$1" ;;
    4) g++ "$1" -o /tmp/$(basename "$1") && chmod +x /tmp/$(basename "$1") && /tmp/$(basename "$1") ;;
    *) printf "${BRed}Oops somting went wrong." ;;
    esac
}

function tryRunning() {
    declare -a files=("text/x-shellscript" "text/x-c" "application/java-archive" "text/x-python" "text/x-c++")
    for ((i = 0; i < ${#files[@]}; i++)); do
        if [[ $(file --mime-type -b "$1") == ${files[$i]} ]]; then
            printf "${BYellow}Do you want to run this file ?\n"
            printf "${BPurple}Press enter to run. Any other key to view scource.${White}\n"
            read -s -n 1 key
            if [[ $key == "" ]]; then
                printf "${BCyan}Starting excecution${White}\n"
                time runFile $1 $i
                printf "\n${BCyan}End of excecution${White}\n"
            else
                getTextEditor "$1"
            fi
            ran=true
            return 0
        fi
    done
    ran=false
}

if ! [ -f "$pword" ]; then
    printf "${BRed}It seems like you don't have sudo password saved.\n"
    printf "${BPurple}Enter it now to save it !\n"
    printf "${BCyan}To modify it later change it in ${UCyan}$pword${BCyan} file.${White}\n"
    read -s pass
    printf $pass | sudo -S touch "$root"
    while ! [ -f "/bin/a" ]; do
        read -s pass
        echo "$pass" | sudo -S -k touch "$root"
        printf "${BRed}Oops Wrong Password\n"
        printf "${BPurple}Please try again${White}\n"
    done
    sudo rm "$root"
    echo "$pass" >"$pword"
    echo "$pass" | sudo -S -i
    clear
    printf "\n\n"
fi

ver=$(curl $version)
clear
if [[ $(cat './.version') != $ver ]]; then
    printf "${BGreen}A new version of RunneR is avalable\n"
    printf "${BYellow}Do you want to upgrade ? ${Choise}\n"
    getChoise
    if [ $choise == true ]; then
        printf "${BPurple}Updating...${White}\n"
        git reset HEAD --hard
        git clean -f
        git pull origin master
        printf "${BPurple}Press enter to continue.${White}\n"
        read -s -n 1 a
    fi
    clear
    printf "\n\n"
fi

cd "$cwd"
if ! [ -f "$1" ]; then
    printf "${BYellow}Which file do you want to run ?\n"
    read file
    $1="$file"
fi        
tryRunning "$1"
if [[ $(file --mime-type -b "$1") == "application/x-sharedlib" ]]; then
    printf "${BYellow}Do you want to run this application ? ${Choise}\n"
    getChoise
    if [[ $choise == true ]]; then
        printf "${BCyan}Starting application${White}\n"
        chmod +x "$1" && "$1"
        printf "\n${BCyan}End of excecution${White}\n"
    else
        printf "${BRed}Excecution Canceled\n"
    fi
elif [[ $(file --mime-type -b "$1") == "application/x-dosexec" ]]; then
    printf "${BYellow}Do you want to run this application ? ${Choise}\n"
    getChoise
    if [[ $choise == true ]]; then
        printf "${BCyan}Starting application${White}\n"
        chmod +x "$1" && wine "$1"
        printf "\n${BCyan}End of excecution${White}\n"
    else
        printf "${BRed}Excecution Canceled\n"
    fi
elif [[ $(file --mime-type -b "$1") == "application/vnd.debian.binary-package" ]]; then
    printf "${BYellow}Are you sure you want to install this package ? ${Choise}\n"
    getChoise
    if [[ $choise == true ]]; then
        printf "${BCyan}Starting installation${White}\n"
        cat "$pword" | sudo -S dpkg -i "$1"
        printf "${BCyan}End of installation${White}\n"
    else
        printf "${BRed}Installation Canceled\n"
    fi
elif [ $ran == false ]; then
    printf "${BRed}Sorry Unsupported file type.\n"
    printf "${BPurple}If you want to add support for this file type please file an issue on github.\n"
    printf "${BCyan}visit https://github.com/rohittp0/Shell-Run \n"
    printf "File type "$(file --mime-type -b "$1")"\n\n"
fi

printf "${BPurple}Press enter to continue.${White}\n"
read -s -n 1 key
