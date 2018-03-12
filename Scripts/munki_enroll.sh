#!/bin/sh 

##### Tweak on the original Munki-Enroll
##### This has different logic based on whether the computer is a desktop or a laptop
##### If it's a laptop, the script grabs the user's full name
##### If it's a desktop, the script just grabs the computer's name
##### This version of the script also assumes you have an https-enabled Munki server with basic authentication
##### Change SUBMITURL's variable value to your actual URL
##### Also change YOURLOCALADMINACCOUNT if you have one

#######################
## User-set variables
# Change this URL to the location fo your Munki Enroll install
SUBMITURL="http://example.com/repo/munki-serial-enroll/enroll.php"
# Change this to a local admin account you have if you have one
ADMINACCOUNT="ADMINACCOUNT"
#######################

# Make sure there is an active Internet connection
SHORTURL=$(echo "$SUBMITURL" | awk -F/ '{print $3}')
PINGTEST=$(ping -o -t 4 "$SHORTURL" | grep "64 bytes")

if [ ! -z "$PINGTEST" ]; then

   # Get the serial number
   SERIAL=$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Serial Number/ { print $4; }')
   # Make the "display name" into the actual computer name
   DISPLAYNAME=$(/usr/sbin/scutil --get ComputerName | /usr/bin/sed 's/ /-/g')
   # Get the primary user
   PRIMARYUSER=''
   # This is a little imprecise, because it's basically going by process of elimination, but that will pretty much work for the setup we have
   cd /Users
   for u in *; do
      if [ "$u" != "Guest" ] && [ "$u" != "Shared" ] && [ "$u" != "root" ] && [ "$u" != "$ADMINACCOUNT" ]; then
         PRIMARYUSER="$u"
      fi
   done

   if [ "$PRIMARYUSER" != "" ]; then
	   
      # Get User Name
      USERNAME=$(/usr/bin/dscl . -read /Users/"$PRIMARYUSER" dsAttrTypeStandard:RealName | /usr/bin/sed 's/RealName://g' | /usr/bin/tr '\n' ' ' | /usr/bin/sed 's/^ *//;s/ *$//' | /usr/bin/sed 's/ /%20/g')   

   else
      
      USERNAME="Undefined%20-%20Fix%20Later"
   fi
   # Get the authorization information
   AUTH=$( managedsoftwareupdate --show-config | /usr/bin/awk -F 'Basic ' '{print $2}' | /usr/bin/sed 's/.$//' | /usr/bin/base64 --decode )

   # Send information to the server to make the manifest
   /usr/bin/curl --max-time 5 --silent --get \
      -d displayname="$DISPLAYNAME" \
      -d serial="$SERIAL" \
      -d username="$USERNAME" \
      -u "$AUTH" "$SUBMITURL"
      # If not basic authentication, then just "$SUBMITURL" for the last line 

   # Delete the ClientIdentifier, since we'll be using the serial number
   function deleteClientIdentifier {
      clientIdentifier=$(defaults read "$1" | grep "ClientIdentifier")
      if [ ! -z "$clientIdentifier" ]; then
         sudo /usr/bin/defaults delete "$1" ClientIdentifier
      fi 
   }
   
   deleteClientIdentifier "/Library/Preferences/ManagedInstalls"
   deleteClientIdentifier "/var/root/Library/Preferences/ManagedInstalls"

else
   # No good connection to the server
   exit 1
fi
