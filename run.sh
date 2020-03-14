#!/bin/bash
cwd=$(pwd)
cd "$(dirname "$(readlink -fm "$0")")"

pword="./password.shadow"
root="/bin/a"
if [ -f "$pword" ]; then
    cat "$pword" | sudo -S -i
else
    echo "It seems like you don't have sudo password saved."
    echo "Enter it now to save it."
    echo "To modify it later change it in $pword file."
    read pass
    echo $pass | sudo -S touch "$root"
    while ! [ -f "/bin/a" ]; do
        read pass
        echo "$pass" | sudo -S touch "$root"
    done
    sudo rm "$root"
    echo "$pass" >"$pword"
fi

clear

UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "RunneR is Up-to Date"
else
    echo "A new version of RunneR is avalable"
    echo "Do you want to upgrade (y/n) ?"
    read -s -n 1 key
    if [[ $key == 'y' ]]; then
        git fetch --all
        git reset --hard origin/master
    fi
fi

clear
cd "$cwd"

if [[ $(file --mime-type -b "$1") == "text/x-shellscript" ]]; then
    echo "Do you want to run this script ?"
    echo "Press enter to run. Any other key to view scource."
    read -s -n 1 key
    if [[ $key = "" ]]; then
        echo "Starting excecution" >>"$1.log"
        sh "$1" >>"$1.log"
        echo "End of excecution" >>"$1.log"
    else
        gedit "$1"
    fi
elif [[ $(file --mime-type -b "$1") == "text/x-python" ]]; then
    echo "Do you want to run this python script ?"
    echo "Press enter to run. Any other key to view scource."
    read -s -n 1 key
    if [[ $key = "" ]]; then
        echo "Running script" >>"$1.log"
        python "$1" >>"$1.log"
        echo "End of excecution" >>"$1.log"
    else
        gedit "$1"
    fi
else
    echo "Are you sure you want to install this package ? (y/n)"
    read -s -n 1 key
    if [[ $key = "y" ]]; then
        echo "Starting installation" >>"$1.log"
        sudo dpkg -i "$1" >>"$1.log"
        echo "End of installation" >>"$1.log"
    else
        echo "Installation canceled"
    fi
fi
read -s -n 1 key
