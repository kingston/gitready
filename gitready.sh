#!/bin/bash

#
# Git Ready
#
# A very simple script to get git set-up along with the necessary keys
#
# Inspiration: https://github.com/joshfng/railsready
#

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi


control_c()
{
  echo -en "\n\n*** Exiting ***\n\n"
  exit 1
}

USER_HOME=$(eval echo ~${SUDO_USER})

# trap keyboard interrupt (control-c)
trap control_c SIGINT

if command -v aptitude >/dev/null 2>&1 ; then
  pm="aptitude"
else
  pm="apt-get"
fi

if [ ! -d "$USER_HOME/.ssh" ]; then
    mkdir $USER_HOME/.ssh
fi

if [ ! -f "$USER_HOME/.ssh/id_rsa" ]; then
    echo "Setting up SSH keys..."
    read -p "Please enter the email address to associate with it: " email
    ssh-keygen -t rsa -C $email -f $USER_HOME/.ssh/id_rsa
    echo "SSH keys generated!"
else
    echo "SSH keys found, skipping step!"
fi

echo "Installing git..."

sudo $pm -y install git-core

echo "done!"
echo ""
echo ""

echo "Go to https://github.com/settings/ssh and add the following key:"

cat ~/.ssh/id_rsa.pub
