# Uninstall Shiny Server (reverse of install), tested January 24, 2021

# Go to home directory
cd ~/

# Stop shiny-server
sudo systemctl stop shiny-server

# Remove service
sudo rm /lib/systemd/system/shiny-server.service

# Remove shiny-server related dirs
sudo rm -r /srv/shiny-server
sudo rm -r /var/log/shiny-server
sudo rm -r  /var/lib/shiny-server
sudo rm -r /etc/shiny-server

# Remove shiny user
sudo userdel -r shiny

# Remove link to shiny-server executable
sudo rm /usr/bin/shiny-server

# Remove system location of shiny-server
sudo rm -r /usr/local/shiny-server

# Remove all R-related system and language libraries
sudo apt-get remove r-base-core --purge -y
dpkg -l | grep ^ii | awk '$2 ~ /^r-/ { print $2 }' | sudo xargs apt-get remove --purge -y
sudo rm -r /usr/local/lib/R

# Remove the shiny-server directory
rm -rf tmp/shiny-server

# Finish
sudo apt autoremove -y
sudo apt-get -y update && sudo apt-get -y upgrade
sudo systemctl daemon-reload