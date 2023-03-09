#!/bin/bash

# Sorry for crappy bash scripting (I am indeed a bash brainlet!)

help_string="Purpose: This Will copy your local (/etc/fonts/local.conf) font configuration file so that it can be recognized by the flatpak app. 
----------------------------------------------------------
Usage: ./flatpak-fonts-setup.sh [Application-id(of your app)]
The Application id is included with your application (they can be obtained from the 'flatpak list' command):
Firefox -> org.mozilla.firefox (for.eg)
----------------------------------------------------------
Other Usage: ./flatpak-fonts-setup.sh -h/--help 
Display this Help Message
----------------------------------------------------------
Example:
To Setup Fonts for Firefox(org.mozilla.firefox):
./flatpak-fonts-setup.sh org.mozilla.firefox
- If the output is 'Done!', you are good!
- If it says 'Please run that application Once and Retry!, Or see if it is even installed!', then do so accordingly.
"

case "$1" in
	-h|--help) echo $help_string ; exit 0 ;;
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
