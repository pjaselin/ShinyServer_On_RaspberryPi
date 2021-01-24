# Shiny Server on Raspberry Pi with R

If you want to use place a Shiny Server on a Raspberry Pi, 1) yes the RPi can handle it! 2) these scripts will allow you to do it effortlessly. Regarding the performance of a Shiny Server on a Raspberry Pi, the device seems to handle it quite well and I haven't seen significant processing/speed issues.

## Contents
- [Warnings](#Warnings)
- [Inportant Tasks Solved in the Script](#Important-Tasks-Solved-in-the-Script)
- [Installation with Stable R](#Installation-with-Stable-R)
- [Installation with Backport R](#Installation-with-Backport-R)
- [Uninstall Shiny-Server and R](#Uninstall-Shiny-Server-and-R)
- [Future Maintenance](#Future-Maintenance)


## Warnings
This script is provided "as is" with no warranty of any kind. As such, users should read the script to ensure they are confident in its integrity. However the script is well contained and should not interfere with anything on the RPi beyond Shiny Server-related tasks. This has been tested and is known to work as of January 24, 2021.


## Important Tasks Solved in the Script
- Handles system library dependencies for installing and running a Shiny Server
- Installs all R packages required for Shiny Server to start and index.html to successfully open
- Edits external/node/install-node.sh to obtain the correct NodeJS installation for a Raspberry Pi
- Builds Shiny Server via packaging/make-package.sh
- Configures Shiny Server, sets up initial server applications, and places all the required system directories
- Resolves Pandoc issues stemming from Shiny Server using it's packaged Pandoc distribution by removing this directory and giving the system-installed version precedence


## Installation with Stable R

The provided Stable_RPiShinyServer.sh script will install the latest Shiny Server distribution along with the stable R version via the following command (N.B. the script takes awhile to run due to the R library installations):
```bash
wget -O - https://raw.githubusercontent.com/pjaselin/ShinyServer_On_RaspberryPi/master/Stable_RPiShinyServer.sh | bash
```

## Installation with Backport R

NOT FULLY FUNCTIONAL: Due to the new release of R 3.5.2, the R backport will not correctly install the lastest version of R and the required packages. However, Shiny Server will correctly install.

```bash
git clone https://github.com/pjaselin/ShinyServer_On_RaspberryPi.git
cd ShinyServer_On_RaspberryPi
bash Backport_RPiShinyServer.sh
```

## Uninstall Shiny Server and R
The to remove Shiny Server AND R, please run the following command to execute the Uninstall_RPiShinyServer.sh script:
```bash
wget -O - https://raw.githubusercontent.com/pjaselin/ShinyServer_On_RaspberryPi/master/Uninstall_RPiShinyServer.sh | bash
```


## Future Maintenance
I will try to keep this updated as the Shiny Server repo develops. Please submit issues if you run into problems and I'll do my best to make changes to the script as necessary. PRs are also welcome!