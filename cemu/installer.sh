#!/bin/bash
##################################################################################################################################
#---------------------------------------------------------------------------------------------------------------------------------




app=wiiuplus




#---------------------------------------------------------------------------------------------------------------------------------
##################################################################################################################################
export DISPLAY=:0.0 ; cd /tmp/ ; rm "/tmp/pro-framework.sh" 2>/dev/null ; rm "/tmp/$app.sh" 2>/dev/null ;
wget --no-check-certificate --no-cache --no-cookies -q -O "/tmp/pro-framework.sh" "https://github.com/profork/profork/raw/master/.dep/pro-framework.sh" ; 
wget --no-check-certificate --no-cache --no-cookies -q -O "/tmp/$app.sh" "https://github.com/profork/profork/raw/master/$app/$app.sh" ; 
dos2unix /tmp/pro-framework.sh ; dos2unix "/tmp/$app.sh" ;  
source /tmp/pro-framework.sh  
bash "/tmp/$app.sh"
# PROFORK // 
