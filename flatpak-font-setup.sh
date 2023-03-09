#!/bin/bash

help_string="Help:
- Please Pass the Application id (i.e App.id in 'flatpak --list' of an app)
- Don't Include runtimes!
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
			echo "Please run that application Once and Retry!"
		fi
		;;
esac
