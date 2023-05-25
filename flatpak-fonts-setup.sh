#!/bin/bash

# Sorry for crappy bash scripting (I am indeed a bash brainlet!)
# Also this script is bloated as ****.
# Feature creep!!!!!!

# Important!
# You need to have /etc/fonts/local.conf file, an local.conf.example one is included in this directory!

help_string="Purpose: This Will copy your global (/etc/fonts/local.conf) font configuration file so that it can be recognized by the flatpak app(s).\n
----------------------------------------------------------\n
Usage: ./flatpak-fonts-setup.sh [Application-id(of your app)]\n
Note: *This option takes the Application-id of your app as input*\n
This will copy the global fontconfig to the directory location for your app so it can be recognized by the app.\n
The Application id is included with your application (they can be obtained from the 'flatpak list' command):\n
Firefox -> org.mozilla.firefox (for.eg)\n
----------------------------------------------------------\n
Usage(2): ./flatpak-fonts-setup.sh -h/--help\n
Note: *This option does not take any input*\n
This will display this Help Message\n
----------------------------------------------------------\n
Usage(3): ./flatpak-fonts-setup.sh -m/--memoize [Application-id(of your app)]\n
Note: *This option takes the Application-id of your app as input*\n
This will write your application's id to a memo located in the user's .local/share/ directory...\n
The purpose of this feature is to maintain a small file that will store application-id(s),\n
that can be used to update the fontconfig(s) of all those applications at once!\n
Note: As of Now Entries can be duplicated!\n
----------------------------------------------------------\n
Usage(4): ./flatpak-fonts-setup.sh -M/--memorun\n
Note: *This option does not take any input*\n
This will update the fontconfig(s) of all your applications stored in the memo...\n
----------------------------------------------------------\n
Usage(5): ./flatpak-fonts-setup.sh -e\n
Note: *This option does not take any input*\n
This will show usage examples.\n
----------------------------------------------------------\n
"

usage_examples="
----------------------------------------------------------\n
Example(1):\n
----------------------------------------------------------\n
Setup for a flatpak(org.mozilla.Firefox i.e Firefox) app:\n
1. First make sure that the application is installed!\n
2. Make sure to run the application first(Firefox in our case), before running the script, \n
   so that the respective directory locations are set up.\n
3. Run 'flatpak-fonts-setup.sh' followed by the application's id (in our case 'org.mozilla.Firefox').\n
----------------------------------------------------------\n
Example(2):\n
----------------------------------------------------------\n
If you want to store the name(s) of the application(s) you have installed,\n
so there fontconfig(s) can be updated all at once then you can use the\n
'Memoization feature'! like this :\n
1. First store the Application-id(s) in the memo by:\n
   './flatpak-fonts-setup.sh -m *Application-id*'\n
2. Then by running './flatpak-fonts-setup.sh -M', there fontconfig(s)\n
   can be updated all at once!\n
3. Since there application-id(s) are stored in the memo, in the future\n
   the fontconfig(s), can be updated by repeating only the second step.\n
----------------------------------------------------------\n
Example(3):\n
----------------------------------------------------------\n
List the contents of the Memo by:\n
'./flatpak-fonts-setup.sh --memocat'\n
"

# Check if /etc/fonts/local.conf if present
if [ ! -f /etc/fonts/local.conf ]; then
	echo "Sorry you need to have a fontconfig file named 'local.conf' in your /etc/fonts dir for this to work!" ; exit 1
fi
# Actual Part

case "$1" in
	-h|--help) echo -e $help_string ; exit 0 ;;
	-e) echo -e $usage_examples ; exit 0 ;;
	-m|--memoize)
		mkdir -p "$HOME/.local/share/flatpak-fonts-setup/"
		touch "$HOME/.local/share/flatpak-fonts-setup/memo.memo"
		if [[ ! -z "$2" ]] && [[ -d "$HOME/.var/app/$2" ]]; then
			echo "$2" >> "$HOME/.local/share/flatpak-fonts-setup/memo.memo" ; echo "Successfully written to the memo!"
		else
			echo "Invalid Input!"
		fi
		;;

	-M|--memorun)
		mkdir -p "$HOME/.local/share/flatpak-fonts-setup/"
		touch "$HOME/.local/share/flatpak-fonts-setup/memo.memo"
		while IFS= read -r line
		do
		  mkdir -p "$HOME/.var/app/$line/config/fontconfig" ; cp "/etc/fonts/local.conf" "$HOME/.var/app/$line/config/fontconfig/fonts.conf" ; echo "Done! for $line"
		done < "$HOME/.local/share/flatpak-fonts-setup/memo.memo"
		;;
	--memocat) cat "$HOME/.local/share/flatpak-fonts-setup/memo.memo" ;;
	-*) echo "This switch is not supported!" ; exit 1 ;;
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

