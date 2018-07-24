#!/bin/bash
#Usage: sudo sh new_user.sh
#Creates a new user, prompted on command line.
#Alternate usage: sudo sh new_user.sh [fullname] [username] [uid] [password]
RED='\033[0;31m'
RESET='\033[0m'

if [ -z "$1" ]; then
	read -p "$(echo "Define a full name, can be pretty long (30 characters) \nType the user's full name, (e.g. John Wu): ")" fullname
	read -p "$(echo "Define a Username: No special characters or spaces alowed.\nType the username (e.g. wurules): ")" username
	read -p "$(echo "Select a user ID. This is a UNIQUE number between 503 and 1000\nMac sets the first account (admin) 501, second (jamfadmin) 502, etc.\nType the user ID (Unique, 503-1000): ")" uid
	read -p "$(echo "Set the password. In plain text, so use change,me\nType the password (plain text, e.g. change,me): ")" changeme
else
	fullname=$1
	username=$2
	uid=$3
	changeme=$4
fi

#Create account
dscl . -create /Users/$username
#Activate the shell (bash RULES tcsh DROOLS)
dscl . -create /Users/$username shell /bin/bash
#Set user ID
dscl . -create /Users/$username uid "$uid"
#Set primary group to Staff (default behavior)
dscl . -create /Users/$username gid 20
#Set full name
dscl . -create /Users/$username realname "$fullname"
#Set home directory
dscl . -create /Users/$username NFSHomeDirectory /Users/$username
#Set password
dscl . -passwd /Users/$username $changeme
#Elevate to admin
dscl . -append /Groups/admin GroupMembership $username

#Allows user to unlock by filevault
echo "Type in the admin password, then the password set above"
fdesetup add -usertoadd $username
