#!/bin/sh

##
##            _                                         
##  |\/| ._  |_)   _|_  _   \    / _.  _  |_|  _  ._ _  
##  |  | | o |_) \/ |_ (/_   \/\/ (_| _>  | | (/_ | (/_ 
##               /                                      
##
##

## PACKAGES THAT ARE REQUIRED
echo Password Require To Download Files
sudo apt-get install xz-utils -y
mkdir /home/"$USER"/fivem/
cd /home/"$USER"/fivem/ || exit
echo downloading FiveM Artifacts
wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/1920-971227271da8099b386bcde54e0f557481489e6e/fx.tar.xz
tar xf fx.tar.xz
rm fx.tar.xz

## CREATING DIRECTORIES AND ENTERING THEM
echo Making directories under /home/"$USER"/fivem/server
mkdir /home/"$USER"/fivem/server-data
chmod 777 -R /home/"$USER"/fivem/
cd server-data || exit
git clone https://github.com/citizenfx/cfx-server-data.git
sudo mv  -v ~/fivem/server-data/cfx-server-data/resources /home/"$USER"/fivem/server-data/
sudo rm -r /home/"$USER"/fivem/server-data/cfx-server-data/

## DOWNLOADING SERVER.CFG FROM MY SERVER LEL
wget  https://idobyte.com/server.cfg

# Prompt the user for server key input
echo "Enter Server Key: "
read KEY

# Prompt the user for server name input
echo "Enter A Name For Your Server: "
read NAME

# Update the configuration file
echo "# Only change the IP if you're using a server with multiple network interfaces, otherwise change the port only.
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

# These resources will start by default.
ensure mapmanager
ensure chat
ensure spawnmanager
ensure sessionmanager
ensure fivem
ensure hardcap
ensure rconlog
ensure scoreboard

# This allows players to use scripthook-based plugins such as the legacy Lambda Menu.
# Set this to 1 to allow scripthook. Do note that this does _not_ guarantee players won't be able to use external plugins.
sv_scriptHookAllowed 0

# Uncomment this and set a password to enable RCON. Make sure to change the password - it should look like rcon_password "YOURPASSWORD"
#rcon_password ""

# A comma-separated list of tags for your server.
# For example:
# - sets tags "drifting, cars, racing"
# Or:
# - sets tags "roleplay, military, tanks"
sets tags "default, mr.byte"

# A valid locale identifier for your server's primary language.
# For example "en-US", "fr-CA", "nl-NL", "de-DE", "en-GB", "pt-BR"
sets locale "en-US" 
# please DO replace root-AQ on the line ABOVE with a real language! :)

# Set an optional server info and connecting banner image url.
# Size doesn't matter, any banner sized image will be fine.
#sets banner_detail "https://url.to/image.png"
#sets banner_connecting "https://url.to/image.png"

# Set your server's hostname
sv_hostname ${NAME}

# Nested configs!
#exec server_internal.cfg

# Loading a server icon (96x96 PNG file)
#load_server_icon myLogo.png

# convars which can be used in scripts
#set temp_convar "hey world!"

# Uncomment this line if you do not want your server to be listed in the server browser.
# Do not edit it if you *do* want your server listed.
#sv_master1 ""

# Add system admins
add_ace group.admin command allow # allow all commands
add_ace group.admin command.quit deny # but don't allow quit
add_principal identifier.steam:110000100000000 group.admin # add the admin to the group

# Hide player endpoints in external log output.
sv_endpointprivacy true

# Server player slot limit (must be between 1 and 32, unless using OneSync)
sv_maxclients 32

# License key for your server (https://keymaster.fivem.net)
sv_licenseKey ${KEY}" > server.cfg

#CHMOD THE RUN FILE SO IT CAN BE EXECUTED
chmod 777 /home/"$USER"/fivem/run.sh

#SHOW TIME BABY ENJOY
echo Starting FiveM Server...
cd /home/"$USER"/fivem/server-data/ || exit

#Prompt to start server.
while true; do
    read -p "Do you wish to start the server?" yn
    case $yn in
        [Yy]* ) bash /home/"$USER"/fivem/run.sh +exec server.cfg; break;;
        [Nn]* )echo "Have a good day"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
