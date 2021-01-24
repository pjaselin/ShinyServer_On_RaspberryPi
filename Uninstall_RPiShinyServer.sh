# Uninstall Shiny Server (reverse of install)

# stop shiny-server
sudo systemctl stop shiny-server
# remove service
sudo rm /lib/systemd/system/shiny-server.service

# remove shiny-server dirs
sudo rm -r /srv/shiny-server
sudo rm -r /var/log/shiny-server
sudo rm -r  /var/lib/shiny-server
sudo rm -r /etc/shiny-server

# remove shiny user
sudo userdel -r shiny

# remove link to shiny-server executable
sudo rm /usr/bin/shiny-server

# remove system location of shiny-server
sudo rm -r /usr/local/shiny-server

# remove all R-related system and language libraries
sudo apt-get remove r-base-core --purge
dpkg -l | grep ^ii | awk '$2 ~ /^r-/ { print $2 }' | sudo xargs apt-get remove --purge -y
sudo rm -r /usr/local/lib/R


# finish
sudo apt autoremove -y
sudo apt-get -y update && sudo apt-get -y upgrade
sudo systemctl daemon-reload