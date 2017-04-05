!/bin/bash

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

# install apps
sudo apt-get install \
	spotify-client git filezilla skype\
	openbox obconf

# remove unwanted default folders
rm -rf ~/Documents
rm -rf ~/Public
rm -rf ~/Templates
rm -rf ~/Videos
rm -rf ~/Music
rm -rf ~/examples.desktop

# copy dotfiles, clone dotfiles to /data first
shopt -s dotglob
cp -ar ./data/dotfiles/* ~

# setup workspace
mkdir ~/Development
mkdir ~/Development/Python
mkdir ~/Development/Ruby
mkdir ~/Development/CPP

