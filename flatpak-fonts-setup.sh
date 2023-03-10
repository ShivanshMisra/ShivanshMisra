#!/bin/bash

# Sorry for crappy bash scripting (I am indeed a bash brainlet!)

# Important!
# You need to have /etc/fonts/local.conf file, an local.conf.example one is included in this directory!

help_string="Purpose: This Will copy your local (/etc/fonts/local.conf) font configuration file so that it can be recognized by the flatpak app.\n
----------------------------------------------------------\n
Usage: ./flatpak-fonts-setup.sh [Application-id(of your app)]\n
The Application id is included with your application (they can be obtained from the 'flatpak list' command):\n
Firefox -> org.mozilla.firefox (for.eg)\n
----------------------------------------------------------\n
Other Usage: ./flatpak-fonts-setup.sh -h/--help\n
Display this Help Message\n
----------------------------------------------------------\n
Example:\n
To Setup Fonts for Firefox(org.mozilla.firefox):\n
./flatpak-fonts-setup.sh org.mozilla.firefox\n
- If the output is 'Done!', you are good!\n
- If it says 'Please run that application Once and Retry!, Or see if it is even installed!', then do so accordingly.\n
"

# Check if /etc/fonts/local.conf if present
if [ ! -f /etc/fonts/local.conf ]; then
	echo "Sorry you need to have a fontconfig file named 'local.conf' in your /etc/fonts dir for this to work!" ; exit 1
fi
# Actual Part

case "$1" in
	-h|--help) echo -e $help_string ; exit 0 ;;
	-*) echo "Only the -h switch is supported!" ; exit 1 ;;
	*) 
		if [[ -z "$1" ]]; then
			echo "No application specified! No change done!"
		elif [ -d "$HOME/.var/app/$1" ]; then
			mkdir -p "$HOME/.var/app/$1/config/fontconfig" ; cp "/etc/fonts/local.conf" "$HOME/.var/app/$1/config/fontconfig/fonts.conf" ; echo "Done!"
		else
			echo "Please run that application Once and Retry!, Or see if it is even installed!"
		fi
		;;
esac
