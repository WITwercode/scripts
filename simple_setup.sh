#!/bin/bash
# Usage: sudo sh simple_setup.sh
# Asks for First Name, Last Name, and previous file loc and then proceeds with setup
# User creation, file transfer, launch update included.
# If apass given (as arg), automatically enables filevaule access for account
# Arguments: sudo sh simple_setup.sh [firstName] [lastName] [source] [lib_switch] [launch_switch] [transfer_switch] [encrpyt_switch] [scripts_path] [apass]
# Example: sudo sh simple_setup.sh John Wub "/Users/Test 6" y y y n "/Users/admin/Desktop/git"

scriptsPath="$8"

RED='\033[0;31m'
RESET='\033[0m'
GREEN='\033[0;92m'

if [ -z "$1" ]; then
  read -p "Type the Client's first name: " firstName
  read -p "Type the Client's last name: " lastName

  echo "Concerning the Data transfer: "
  read -p "Is the old computer in Target mode and connected to this computer? (y/n): " noyes
  if [[ "$noyes" == "y" ]]; then
    oldFile="/Volumes/Macintosh HD 1/Users"
    type="user accounts"
  else
    read -p "Is the data on an external hard drive? (y/n): " noyes
    if [[ "$noyes" == "y" ]]; then
      #In this case, we need to check the HFS+ Partition specifically (no users folder in this case)
      oldFile="/Volumes/HFS+ Partition"
      type="folders"
    else
      while [[ "1" == "1" ]]; do
              #Must use not for dummies to customize source location
        read -p "You're doomed. Use setup.sh instead. Press Ctrl + C to exit. " noyes
      done
    fi
  fi

  #Next part is green to highlight part they need to read
  echo "$GREEN"
  ls "$oldFile"
  echo "$RESET"

  #Error check for non-existant input folders
  noyes=1
  while [[ $noyes == 1 ]]; do
    read -p "$(echo "Which of the above $type do you want to transfer?\n(Typically their netID, Last Name, or First Name): ")" oldUser
    fileLoc="$oldFile/$oldUser"
    if [ ! -d "$oldFile/$oldUser" ]; then
      noyes=1
      echo "${RED}This is not a valid choice (Not in the list above) $RESET"
    else
      noyes=0
    fi
  done
else
  firstName=$1
  lastName=$2
  fileLoc=$3
fi

#Sends to lower case
username="$(echo "$lastName" | awk '{print tolower($0)}')"
#Replaces spaces with underscores
username="${username// /_}"

#Copied from new_user.sh
n=503
for listuid in $(dscl . -list /Users UniqueID | awk '{print $2}'); do
  if [ $listuid -gt $n ] || [ $listuid == $n ]; then
    n=$(($listuid+1))
    # echo "ping"
  fi
    # echo "$listuid"
done

uid="$n"

# echo "$firstName $lastName" "$username" "$uid" "change,me"
sh "$scriptsPath"new_user.sh "$firstName $lastName" "$username" "$uid" "change,me" "$7"
if [[ -z "$9" ]]; then
  aPass="$9"
  sh "$scriptsPath"filevault_setup.sh "$userName" "$aPass"
fi

echo ${RED}"User account created----------------------------------------"${RESET}
printf \\a

if [[ "$6" == "n" ]]; then
  echo "No Data Transferred!---------------------------------------------"
else
  sh "$scriptsPath"transfer.sh /Users/"$username" "$username" "$fileLoc" "$4"
  echo ${RED}"Data Transferred---------------------------------------------"${RESET}
  printf \\a
fi

if [[ -z "$5" ]]; then
  read -p "Launch Programs to be updated? (y/n): " noyes
else
  noyes=$5
fi

if [[ "$noyes" == "y" ]]; then
  sh "$scriptsPath"launch_update.sh
fi
