#!/bin/bash

# Ensure script is running with root/sudo
if [[ $(id -u) -ne 0 ]]; then
    echo Please run this script with root/sudo permissions.
    exit
fi

# Run pimpmykali if OS is Kali Linux
if uname -a | grep -q "kali"; then
    git clone https://github.com/Dewalt-arch/pimpmykali.git
    chmod +x ./pimpmykali/pimpmykali.sh && ./pimpmykali/pimpmykali.sh --all --upgrade
fi

# Get username of user
username=$(logname)

#################
#### ALIASES ####
#################
# Create variable for user's .zshrc file
userdir=$(echo "/home/$username")
zshrc=$(echo "$userdir/.zshrc")

# Add section header to .zshrc
echo "" >> $zshrc
echo "# Add custom aliases" >> $zshrc

# Setup alias for sudo
if grep -q "alias sudo-'sudo '" $zshrc; then
    echo "sudo alias already exists."
else
    echo "alias sudo='sudo '" >> $zshrc
    echo "sudo alias added to user's .zshrc."
fi

# Setup openvpn commands for HTB Labs, HTB SP, TryHackMe using files in ./resources dir
if [[ $(ls -d */ | grep -w -c "resources/") -ne 0 ]]; then
    ovpnfiles=$(ls resources/*.ovpn)
    
    if grep -q ".ovpn" $zshrc; then
        echo "Some openvpn configs already exist. Remove all prior ovpn aliases to add from resources dir."
    else
        echo "Openvpn files found."
        for file in $ovpnfiles; do
            if echo $file | grep -q "starting"; then
                echo "alias spovpn='openvpn $userdir/$file'" >> $zshrc
            elif echo $file | grep -q "lab"; then
                echo "alias labovpn='openvpn $userdir/$file'" >> $zshrc
            elif echo $file | grep -q "thm"; then
                echo "alias thmovpn='openvpn $userdir/$file'" >> $zshrc
            fi
        done
        echo "File aliases have been added for HTB Starting Point, HTB Labs, and TryHackMe, as available in resources dir."
    fi
    
    if [[ $(pwd) != "$userdir" ]]; then
        mv resources $userdir
        echo "Moved resources dir to user's home directory."
    fi
fi
