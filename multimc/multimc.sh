#!/usr/bin/env bash 
# PROFORK INSTALLER
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
#--------------------------------------------------------------------- 
#       DEFINE APP INFO >>
APPNAME=multimc
APPLINK=https://files.multimc.org/downloads/mmc-stable-lin64.tar.gz
APPHOME="multimc.org" 
#---------------------------------------------------------------------
#       DEFINE LAUNCHER COMMAND >>
COMMAND='mkdir /userdata/system/pro/'$APPNAME'/home 2>/dev/null; mkdir /userdata/system/pro/'$APPNAME'/config 2>/dev/null; mkdir /userdata/system/pro/'$APPNAME'/roms 2>/dev/null; LD_LIBRARY_PATH="/userdata/system/pro/.dep:${LD_LIBRARY_PATH}" QT_PLUGIN_PATH=/usr/lib/qt/plugins QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/qt/plugins HOME=/userdata/system/pro/'$APPNAME'/home XDG_CONFIG_HOME=/userdata/system/pro/'$APPNAME'/config QT_SCALE_FACTOR="1" GDK_SCALE="1" XDG_DATA_HOME=/userdata/system/pro/'$APPNAME'/home DISPLAY=:0.0 /userdata/system/pro/'$APPNAME'/MultiMC'
#--------------------------------------------------------------------- 
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
# --------------------------------------------------------------------
APPNAME="${APPNAME^^}"; ORIGIN="${APPHOME^^}"; appname=$(echo "$APPNAME" | awk '{print tolower($0)}'); AppName=$appname; APPPATH=/userdata/system/pro/$appname/$AppName.AppImage
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# show console/ssh info: 
clear
echo
echo
echo
echo
echo -e "${X}PREPARING $APPNAME INSTALLER, PLEASE WAIT . . . ${X}"
echo
echo 
echo
echo
# --------------------------------------------------------------------
# -- output colors:
###########################
X='\033[0m'               # 
W='\033[0m'               # 
#-------------------------#
RED='\033[0m'             # 
BLUE='\033[0m'            # 
GREEN='\033[0m'           # 
PURPLE='\033[0m'          # 
DARKRED='\033[0m'         # 
DARKBLUE='\033[0m'        # 
DARKGREEN='\033[0m'       # 
DARKPURPLE='\033[0m'      # 
###########################
# --------------------------------------------------------------------
# -- console theme
L=$X
R=$RED
# --------------------------------------------------------------------
# -- prepare paths and files for installation: 
cd ~/
pro=/userdata/system/pro
mkdir $pro 2>/dev/null
mkdir $pro/extra 2>/dev/null
mkdir $pro/$appname 2>/dev/null
mkdir $pro/$appname/extra 2>/dev/null
# --------------------------------------------------------------------
# -- pass launcher command as cookie for main function: 
command=$pro/$appname/extra/command; rm $command 2>/dev/null;
echo "$COMMAND" >> $command 2>/dev/null 
# --------------------------------------------------------------------
# -- prepare dependencies for this app and the installer: 
mkdir -p ~/pro/.dep 2>/dev/null && cd ~/pro/.dep && wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O ~/pro/.dep/dep.zip https://github.com/profork/profork/raw/main/.dep/dep.zip && yes "y" | unzip -oq ~/pro/.dep/dep.zip && cd ~/
wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O $pro/$appname/extra/icon.png https://github.com/profork/profork/raw/master/multimc/extra/icon.png; chmod a+x $dep/* 2>/dev/null; cd ~/
chmod 777 ~/pro/.dep/* && for file in /userdata/system/pro/.dep/lib*; do ln -s "$file" "/usr/lib/$(basename $file)"; done
# --------------------------------------------------------------------
# // end of dependencies 
#
# --------------------------------------------------------------------
# -- run before installer:  
killall wget 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null
# --------------------------------------------------------------------
cols=$($dep/tput cols); rm -rf /userdata/system/pro/$appname/extra/cols
echo $cols >> /userdata/system/pro/$appname/extra/cols
line(){
echo 1>/dev/null
}
# -- show console/ssh info: 
clear

echo
echo
echo
echo
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo
echo
echo
echo

sleep 0.33
clear

echo
echo
echo
echo -e '- - - - - - -'
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e '- - - - - - -'
echo
echo
echo

sleep 0.33
clear

echo
echo
echo -e '- - - - - - -'
echo
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo
echo -e '- - - - - - -'
echo
echo

sleep 0.33
clear
echo
line $cols '\'
line $cols '/'
line $cols ' '
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
line $cols ' '
line $cols '/'
line $cols '\'
echo

sleep 0.33
echo
echo -e "${X}THIS WILL INSTALL MULTIMC-LAUNCHER FOR BATOCERA"
echo -e "${X}USING $ORIGIN"
echo
echo -e "${X}$APPNAME WILL BE AVAILABLE IN PORTS"
echo -e "${X}AND ALSO IN THE F1->APPLICATIONS MENU"
echo -e "${X}AND INSTALLED IN /USERDATA/SYSTEM/PRO/$APPNAME"
echo
if [[ "$(java --version | sed '1q;d' | awk '{print $2}')" < "19" ]]; then
echo -e "${R}-------------------------------------------------${W}"
echo -e "${R}YOU WILL ALSO NEED TO INSTALL LATEST JAVA-RUNTIME${W}" 
echo -e "${R}-------------------------------------------------${W}"
fi
echo
echo -e "${X}FOLLOW THE BATOCERA DISPLAY"
echo
echo -e "${X}. . .${X}" 
echo
#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
# --------------------------------------------------------------------
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
# -- THIS WILL BE SHOWN ON MAIN BATOCERA DISPLAY:   
function batocera-pro-installer {
APPNAME="$1"
appname="$2"
AppName="$3"
APPPATH="$4"
APPLINK="$5"
ORIGIN="$6"
# --------------------------------------------------------------------
# -- colors: 
###########################
X='\033[0m'               # 
W='\033[0m'               # 
#-------------------------#
RED='\033[0m'             # 
BLUE='\033[0m'            # 
GREEN='\033[0m'           # 
PURPLE='\033[0m'          # 
DARKRED='\033[0m'         # 
DARKBLUE='\033[0m'        # 
DARKGREEN='\033[0m'       # 
DARKPURPLE='\033[0m'      # 
###########################
# -- display theme:
L=$W
T=$W
R=$RED
B=$BLUE
G=$GREEN
P=$PURPLE
# --------------------------------------------------------------------
cols=$(cat /userdata/system/pro/.dep/display.cfg | tail -n 1)
cols=$(bc <<<"scale=0;$cols/1.3") 2>/dev/null
#cols=$(cat /userdata/system/pro/$appname/extra/cols | tail -n 1)
line(){
echo 1>/dev/null
}

clear

echo
echo
echo
echo -e "${W}PROFORK/${W}$APPNAME${W} INSTALLER ${W}"
echo
echo
echo

sleep 0.33
clear

echo
echo
echo -e '- - - - - - -'
echo -e "${W}PROFORK/${G}$APPNAME${W} INSTALLER ${W}"
echo -e '- - - - - - -'
echo
echo
echo

sleep 0.33
clear

echo
echo -e '- - - - - - -'
echo
echo -e "${W}PROFORK/${W}$APPNAME${W} INSTALLER ${W}"
echo
echo -e '- - - - - - -'
echo
echo

sleep 0.33
clear

echo -e '- - - - - - -'
echo
echo
echo -e "${W}PROFORK/${G}$APPNAME${W} INSTALLER ${W}"
echo
echo 
echo -e '- - - - - - -'

sleep 0.33
clear

echo 
echo
echo
echo -e "${W}PROFORK/${G}$APPNAME${W} INSTALLER ${W}"
echo
echo
echo 

sleep 0.33

echo
echo -e "${W}THIS WILL INSTALL MULTIMC-LAUNCHER FOR BATOCERA"
echo -e "${W}USING $ORIGIN"
echo
echo -e "${W}$APPNAME WILL BE AVAILABLE IN PORTS"
echo -e "${W}AND ALSO IN THE F1->APPLICATIONS MENU"
echo -e "${W}AND INSTALLED IN /USERDATA/SYSTEM/PRO/$APPNAME"
echo
# --------------------------------------------------------------------
# -- check system before proceeding
if [[ "$(uname -a | grep "x86_64")" != "" ]]; then 
:
else
echo
echo -e "${RED}ERROR: SYSTEM NOT SUPPORTED"
echo -e "${RED}YOU NEED BATOCERA X86_64${X}"
echo
sleep 5
exit 0
# quit
exit 0
fi
# --------------------------------------------------------------------
# -- temp for curl download
pro=/userdata/system/pro
temp=/userdata/system/pro/$appname/extra/downloads
rm -rf $temp 2>/dev/null
mkdir -p $temp 2>/dev/null
# --------------------------------------------------------------------
# DOWNLOAD
echo -e "${G}DOWNLOADING${W} MULTIMC-LAUNCHER"
sleep 1
echo -e "${T}$APPLINK" | sed 's,https://,> ,g' | sed 's,http://,> ,g' 2>/dev/null
cd $temp
curl --progress-bar --remote-name --location "$APPLINK"
cd ~/
SIZE=$(($(wc -c $temp/mmc-stable-lin64.tar.gz | awk '{print $1}')/1048576)) 2>/dev/null
echo -e "${T}mmc-stable-lin64.tar.gz   ${T}$SIZE( )MB   ${G}OK${W}  " | sed 's/( )//g'
#
wget -q -O $pro/.dep/tar https://github.com/profork/profork/raw/master/.dep/tar
chmod a+x $pro/.dep/tar
cd $temp
~/pro/.dep/tar -xf $temp/mmc-stable-lin64.tar.gz
cp -rL $temp/MultiMC/* $pro/$appname/
cd ~/
#
# -- fix UID=0 check
sed -i 's,'EUID' '-eq' '0','EUID' '-eq' '-1',g' $pro/$appname/MultiMC 2>/dev/null 
echo
# --------------------------------------------------------------------
rm -rf $temp 2>/dev/null
mkdir $temp 2>/dev/null
echo -e "${G}DOWNLOADING${W} MULTIMC-LIBS"
sleep 1
APPLINK2=https://github.com/profork/profork/raw/master/multimc/extra/libmultimc.zip
echo -e "${T}$APPLINK2" | sed 's,https://,> ,g' | sed 's,http://,> ,g' 2>/dev/null
cd $temp
script -q -c "curl --progress-bar --remote-name --location "$APPLINK2"" /dev/null
cd ~/
SIZE=$(($(wc -c $temp/libmultimc.zip | awk '{print $1}')/1048576)) 2>/dev/null
echo -e "${T}libmultimc.zip   ${T}$SIZE( )MB   ${G}OK${W}" | sed 's/( )//g'
#
cd $temp; mkdir $temp/libmultimc 
yes "A" | unzip -qq $temp/libmultimc.zip -d $pro/$appname/extra/
cd $pro/$appname/extra; rm -rf $pro/$appname/extra/dependencies.txt 2>/dev/null
ls $pro/$appname/extra/lib* | sed 's,^.*/lib,lib,g' >> $pro/$appname/extra/dependencies.txt
cd ~/
#
echo
# --------------------------------------------------------------------
rm -rf $temp 2>/dev/null
mkdir $temp 2>/dev/null
echo -e "${G}DOWNLOADING${W} QT5-FRAMEWORK-LIBS"
sleep 1
APPLINK3=https://github.com/profork/profork/raw/master/multimc/extra/qt5.zip
echo -e "${T}$APPLINK3" | sed 's,https://,> ,g' | sed 's,http://,> ,g' 2>/dev/null
cd $temp
script -q -c "curl --progress-bar --remote-name --location "$APPLINK3"" /dev/null
cd ~/
SIZE=$(($(wc -c $temp/qt5.zip | awk '{print $1}')/1048576)) 2>/dev/null
echo -e "${T}qt5.zip   ${T}$SIZE( )MB   ${G}OK${W}" | sed 's/( )//g'
#
cd $temp; 
yes "A" | unzip -qq $temp/qt5.zip -d $pro/$appname/extra/ 2>/dev/null
cd $pro/$appname/extra; rm -rf $pro/$appname/extra/dependencies.txt 2>/dev/null
ls $pro/$appname/extra/lib* | sed 's,^.*/lib,lib,g' >> $pro/$appname/extra/dependencies.txt
cd ~/
#
echo
# --------------------------------------------------------------------
rm -rf $temp 2>/dev/null
mkdir $temp 2>/dev/null
echo -e "${G}DOWNLOADING${W} QT5-LIBS+" 
sleep 1
APPLINK4=https://github.com/profork/profork/raw/master/multimc/extra/qt5lib.zip
echo -e "${T}$APPLINK4" | sed 's,https://,> ,g' | sed 's,http://,> ,g' 2>/dev/null
cd $temp
script -q -c "curl --progress-bar --remote-name --location "$APPLINK4"" /dev/null
cd ~/
SIZE=$(($(wc -c $temp/qt5lib.zip | awk '{print $1}')/1048576)) 2>/dev/null
echo -e "${T}qt5lib.zip   ${T}$SIZE( )MB   ${G}OK${W}" | sed 's/( )//g'
#
mkdir $pro/.dep/.x86_64-linux-gnu 2>/dev/null
mkdir $pro/.dep/.temp 2>/dev/null
yes "A" | unzip -qq $temp/qt5lib.zip -d $pro/.dep/.temp/ 2>/dev/null
cp -rL $pro/.dep/.temp/x86_64-linux-gnu/* $pro/.dep/.x86_64-linux-gnu/
rm -rf $pro/.dep/.temp 2>/dev/null
cd ~/
#
echo
# --------------------------------------------------------------------
echo
sleep 1.333
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# --------------------------------------------------------------------
echo -e "${G}INSTALLING${W}"
# --------------------------------------------------------------------
# --------------------------------------------------------------------
#rm -rf $temp 2>/dev/null
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# -- prepare launcher to solve dependencies on each run and avoid overlay, 
launcher=/userdata/system/pro/$appname/Launcher
rm -rf $launcher
echo '#!/bin/bash ' >> $launcher
echo 'export LD_LIBRARY_PATH="/userdata/system/pro/java/lib:${LD_LIBRARY_PATH}" ' >> $launcher
echo 'export PATH=/userdata/system/pro/java/bin:$PATH ' >> $launcher
echo 'export JAVA_HOME=/userdata/system/pro/java ' >> $launcher
echo ' # ' >> $launcher
echo ' dep=/userdata/system/pro/.dep; depfile=$dep/dependencies.txt; ' >> $launcher
echo ' nl=$(cat $depfile | wc -l); l=1; while [[ "$l" -le "$((nl+2))" ]]; do ' >> $launcher
echo ' d=$(cat $depfile | sed ""$l"q;d"); if [[ "$(echo $d | grep "lib")" != "" ]]; then ' >> $launcher
echo ' ln -s $dep/$d /lib/$d 2>/dev/null; fi; ((l++)); done ' >> $launcher
#- add extra dependencies: 
echo ' # ' >> $launcher
echo ' dep=/userdata/system/pro/'$appname'/extra; depfile=$dep/dependencies.txt; ' >> $launcher
echo ' nl=$(cat $depfile | wc -l); l=1; while [[ "$l" -le "$((nl+2))" ]]; do ' >> $launcher
echo ' d=$(cat $depfile | sed ""$l"q;d"); if [[ "$(echo $d | grep "lib")" != "" ]]; then ' >> $launcher
echo ' ln -s $dep/$d /lib/$d 2>/dev/null; fi; ((l++)); done ' >> $launcher
#- add qt5libs: 
echo '  # ' >> $launcher
echo '  mkdir -p /usr/lib/x86_64-linux-gnu 2>/dev/null' >> $launcher
echo '  ln -s /userdata/system/pro/.dep/.x86_64-linux-gnu/qt5 /usr/lib/x86_64-linux-gnu/qt5 2>/dev/null' >> $launcher
echo '  ln -s /userdata/system/pro/.dep/.x86_64-linux-gnu/qtchooser /usr/lib/x86_64-linux-gnu/qtchooser 2>/dev/null' >> $launcher
echo '  ln -s /userdata/system/pro/.dep/.x86_64-linux-gnu/qt5-default /usr/lib/x86_64-linux-gnu/qtdefault 2>/dev/null' >> $launcher
echo '   ln -s /userdata/system/pro/.dep/.x86_64-linux-gnu /lib/x86_64-linux-gnu 2>/dev/null;' >> $launcher
echo '   # ' >> $launcher
echo '   unclutter-remote -s' >> $launcher 
echo '#### ' >> $launcher
## -- GET APP SPECIFIC LAUNCHER COMMAND: 
######################################################################
echo "$(cat /userdata/system/pro/$appname/extra/command)" >> $launcher
######################################################################
dos2unix $launcher
chmod a+x $launcher
rm /userdata/system/pro/$appname/extra/command 2>/dev/null
# --------------------------------------------------------------------
# -- prepare f1 - applications - app shortcut, 
shortcut=/userdata/system/pro/$appname/extra/$appname.desktop
rm -rf $shortcut 2>/dev/null
echo "[Desktop Entry]" >> $shortcut
echo "Version=1.0" >> $shortcut
echo "Icon=/userdata/system/pro/$appname/extra/icon.png" >> $shortcut
echo "Exec=/userdata/system/pro/$appname/Launcher" >> $shortcut
echo "Terminal=false" >> $shortcut
echo "Type=Application" >> $shortcut
echo "Categories=Game;batocera.linux;" >> $shortcut
echo "Name=$appname" >> $shortcut
f1shortcut=/usr/share/applications/$appname.desktop
dos2unix $shortcut
chmod a+x $shortcut
cp $shortcut $f1shortcut 2>/dev/null
# --------------------------------------------------------------------
# -- prepare Ports file, 
rm /userdata/roms/ports/MultiMC.sh 2>/dev/null
cp $pro/$appname/Launcher /userdata/roms/ports/MultiMC.sh
# --------------------------------------------------------------------
# -- prepare prelauncher,
pre=/userdata/system/pro/$appname/extra/startup
rm -rf $pre 2>/dev/null
echo "#!/usr/bin/env bash" >> $pre
echo "cp /userdata/system/pro/$appname/extra/$appname.desktop /usr/share/applications/ 2>/dev/null" >> $pre
dos2unix $pre
chmod a+x $pre
# -- add prelauncher to custom.sh to run @ reboot
csh=/userdata/system/custom.sh
if [[ -e $csh ]] && [[ "$(cat $csh | grep "/userdata/system/pro/$appname/extra/startup")" = "" ]]; then
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $csh
fi
if [[ -e $csh ]] && [[ "$(cat $csh | grep "/userdata/system/pro/$appname/extra/startup" | grep "#")" != "" ]]; then
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $csh
fi
if [[ -e $csh ]]; then :; else
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $csh
fi
dos2unix $csh
# -- done. 
sleep 1
echo -e "${G}> ${W}DONE${W}"
echo
sleep 1
echo; #echo -e '- - - - - - -'; echo
echo -e "${G}> ${W}MULTIMC INSTALLED ${G}OK${W}"
echo -e "${G}--${G}------------------${G}--${W}"
echo
if [[ "$(java --version | sed '1q;d' | awk '{print $2}')" < "19" ]]; then
echo -e "${R}--------------------------------------------${W}"
echo -e "${R}YOU ALSO NEED TO INSTALL LATEST JAVA-RUNTIME${W}" 
echo -e "${R}--------------------------------------------${W}"
fi
sleep 4
# reaload for ports file
killall -9 emulationstation
}
export -f batocera-pro-installer 2>/dev/null
# --------------------------------------------------------------------
# RUN:
# |
  batocera-pro-installer "$APPNAME" "$appname" "$AppName" "$APPPATH" "$APPLINK" "$ORIGIN"
# --------------------------------------------------------------------
# PROFORK INSTALLER //
##########################
function autostart() {
  csh="/userdata/system/custom.sh"
  pcsh="/userdata/system/pro-custom.sh"
  pro="/userdata/system/pro"
  rm -f $pcsh
  temp_file=$(mktemp)
  find $pro -type f \( -path "*/extra/startup" -o -path "*/extras/startup.sh" \) > $temp_file
  echo "#!/bin/bash" > $pcsh
  sort $temp_file >> $pcsh
  rm $temp_file
  chmod a+x $pcsh
  temp_csh=$(mktemp)
  grep -vxFf $pcsh $csh > $temp_csh
  mapfile -t lines < $temp_csh
  if [[ "${lines[0]}" != "#!/bin/bash" ]]; then
    lines=( "#!/bin/bash" "${lines[@]}" )
  fi
  if ! grep -Fxq "$pcsh &" $temp_csh; then
    lines=( "${lines[0]}" "$pcsh &" "${lines[@]:1}" )
  fi
  printf "%s\n" "${lines[@]}" > $csh
  chmod a+x $csh
  rm $temp_csh
}
export -f autostart
autostart
exit 0
