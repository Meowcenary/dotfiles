#! /bin/bash

# 11/27/2018
# THIS SCRIPT IS DUBIOUS AT BEST! I can't remember if I ever tested this and if I had
# previously done so, I don't know what the result was. Have no expectations for this to work.

# script to quickly host a ruby on rails project with a local mac osx machine
# making it available across the local network at the machine's IP on port 80
# to access enter this into your web browser address bar: <hosting machine's ip>:80

# find current host IP address, replace en0 with the interface your using
# ipaddress=$(ifconfig | sed -En ‘s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p’)
ipaddress=$(ipconfig getifaddr en0)
export LOCALHOST_IP=$ipaddress

# put your rails project directory here
# cd /Volumes/Storage/Dropbox/Repositories/extendmed/digitalobgyn.com
cd ~/ExtendMedProjects/digitalobgyn.com

# boot WeBRICK
#  sudo is required to bind to port < 1024
# using the -E switch with sudo pulls in the current user
# environment variables, needed for secrets.yml
echo “executing -->  sudo rails server -b $ipaddress -p 80 $ENVIRONMENT”
sudo rm tmp/pids/server.pid  2> /dev/null
sudo -E rails server -b $ipaddress -p 80 $ENVIRONMENT

# setup port forwarding
# sudo ssh -t -L 80:127.0.0.1:8080 user@0.0.0.0
