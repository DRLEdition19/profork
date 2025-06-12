#!/bin/bash

# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi

# Function to display animated title
animate_title() {
    local text="PROFORK APP INSTALLER"
    local delay=0.1
    local length=${#text}

    for (( i=0; i<length; i++ )); do
        echo -n "${text:i:1}"
        sleep $delay
    done
    echo
}

# Function to display controls
display_controls() {
    echo 
    echo "  This Will install Profork app Installer to Ports"
    echo    
    sleep 5  # Delay for 5 seconds
}

# Main script execution
clear
animate_title
display_controls




# Check if /userdata/system/pro does not exist and create it if necessary
if [ ! -d "/userdata/system/pro" ]; then
    mkdir -p /userdata/system/pro
fi



# Download BatoceraPRO.sh to /userdata/roms/ports
curl -L https://github.com/profork/profork/raw/master/app/Profork.sh -o /userdata/roms/ports/Profork.sh

# Download BatoceraPRO.sh.keys to /userdata/roms/ports
wget  https://github.com/profork/profork/raw/master/app/bkeys.txt -P /userdata/roms/ports/

# Set execute permissions for the downloaded scripts
chmod +x /userdata/roms/ports/Profork.sh




sleep 1

mv /userdata/roms/ports/bkeys.txt /userdata/roms/ports/Profork.sh.keys

# Set path where .dialogrc should be
DIALOGRC_PATH="/userdata/system/pro/.dialogrc"
SPLASH_PATH="/userdata/system/pro/pf.mp4"
SPLASH_URL="https://github.com/profork/profork/raw/master/.dep/pf.mp4"

# Ensure the pro directory exists
mkdir -p /userdata/system/pro

# Download .dialogrc if missing
if [ ! -f "$DIALOGRC_PATH" ]; then
    echo "Downloading .dialogrc for dialog color customization..."
    curl -Ls https://github.com/profork/profork/raw/master/.dep/.dialogrc -o "$DIALOGRC_PATH"
fi

# Download splash video if missing
if [ ! -f "$SPLASH_PATH" ]; then
    echo "Downloading Profork splash video..."
    curl -Ls "$SPLASH_URL" -o "$SPLASH_PATH"
fi


echo "Finished.  You should see Profork in Ports. "
sleep 2

echo "(START ➔ GAME SETTINGS ➔ UPDATE GAME LIST) to see in ports."

