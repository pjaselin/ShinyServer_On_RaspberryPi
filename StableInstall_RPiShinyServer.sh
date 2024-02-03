# Install R Shiny Server (stable) on Raspberry Pi 3, tested January 24, 2021
# As per: 
# - https://github.com/rstudio/shiny-server/issues/347
# - https://www.rstudio.com/products/shiny/download-server/
# - https://cloud.r-project.org/bin/linux/debian/#debian-stretch-stable
# - https://github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source
# - http://docs.rstudio.com/shiny-server/#systemd-redhat-7-ubuntu-15.04-sles-12
# - https://www.raspberrypi-spy.co.uk/2015/10/how-to-autorun-a-python-script-on-boot-using-systemd/
# - https://github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source#what-if-a-sufficiently-recent-version-of-cmake-isnt-available

# Start at home directory
cd ~/

# Uninstall Pandoc (Shouldn't be initially installed but doing this to ensure we have a clean install)
sudo apt-get -y remove pandoc

# Update/Upgrade Raspberry Pi and install required apt packages
sudo apt-get -y update \
    && apt-get -y install r-base libssl-dev libcurl4-openssl-dev libboost-atomic-dev pandoc cmake git

# Install R Packages
sudo su - -c "R -e \"install.packages('httpuv', repos='https://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('plotly', repos='https://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('rmarkdown', repos='https://cran.rstudio.com/')\""

# Clone the Shiny Server repository from GitHub in the tmp directory
mkdir -p ~/tmp && cd tmp
git clone https://github.com/rstudio/shiny-server.git && cd shiny-server

# Because we are on a Raspberry Pi, we need to edit the external/node/install-node.sh file to use an ARM-compatible NodeJS installation (https://github.com/nodejs/node#verifying-binaries)
# Get the current Node version for shiny-server
NODE_VERSION=$(cat .nvmrc)
# Get and substitute the correct SHA256 into the install-node.sh file
sed -i "/NODE_SHA256=/c\NODE_SHA256=$(wget -qO- https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt | grep 'linux-armv7l.tar.xz' |  sed -e 's/\s.*$//')" external/node/install-node.sh
# Change x64 to armv7l for the Raspberry Pi
sed -i 's/x64/armv7l/g' external/node/install-node.sh
# Revert NODE_URL to previous format, pulling from nodejs.org url instead of the shiny-server developer's repo
sed -i '/local NODE_URL/c\  local NODE_URL="https://nodejs.org/dist/${NODE_VERSION}/${NODE_FILENAME}"' external/node/install-node.sh

# Build Shiny Server
packaging/make-package.sh

# Remove pandoc from shiny-server repo as we'll use the system pandoc library
rm -r ext/pandoc
cd ..

# Copy Shiny Server directory to system location
sudo cp -r shiny-server/ /usr/local/

# Place a link to the shiny-server executable in /usr/bin
sudo ln -s /usr/local/shiny-server/bin/shiny-server /usr/bin/shiny-server

# Create shiny user. On some systems, you may need to specify the full path to 'useradd'
sudo useradd -r -m shiny

# Create log, config, and application directories
sudo mkdir -p /var/log/shiny-server /srv/shiny-server /var/lib/shiny-server /etc/shiny-server
sudo chown shiny /var/log/shiny-server

# Return to Shiny Server directory and set shiny-server.conf
cd shiny-server
sudo cp config/default.config /etc/shiny-server/shiny-server.conf

# Setup for start at boot
sed -i -e "s:ExecStart=/usr/bin/env bash -c 'exec /opt/shiny-server/bin/shiny-server >> /var/log/shiny-server.log 2>&1':ExecStart=/usr/bin/shiny-server:g"  config/systemd/shiny-server.service
sed -i -e 's:/env::'  config/systemd/shiny-server.service
sudo cp config/systemd/shiny-server.service /lib/systemd/system/
sudo chmod 644 /lib/systemd/system/shiny-server.service

# Enable the shiny-server service
sudo systemctl daemon-reload
sudo systemctl enable shiny-server.service

# Copy Sample apps and index.html to server
sudo cp samples/welcome.html /srv/shiny-server/index.html
sudo cp -r samples/sample-apps/ /srv/shiny-server/

# Start Shiny Server
sudo shiny-server &

# Return to home directory
cd ~/