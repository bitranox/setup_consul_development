#!/bin/bash



# install postgresql
sudo apt-get install wget ca-certificates
wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib -y
sudo apt-get install postgresql-server-dev-all -y
# nur für Desktop !!!
sudo apt-get install pgadmin4 -y




echo "Install Ruby, Postgres for Consul - Tested on Ubuntu Disco Dingo"
sudo apt-get update
sudo apt-get upgrade
sudo apt-get autoremove
sudo apt-get autoclean
sudo apt-get install zlib1g
sudo apt-get install zlib1g-dev
sudo apt-get install git
sudo apt-get install ruby-full
# https://stackoverflow.com/questions/2119064/sudo-gem-install-or-gem-install-and-gem-locations
# use RVM !!!
# Benutzer für Datanbank User und Ruby Server ???
#
sudo gem install bundler
sudo apt-get install nodejs
sudo apt-get install npm



# install tools
sudo apt-get install meld


read -p "Press enter to continue"
