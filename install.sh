#!/bin/bash
#title           : install.sh
#description     : This script will make the install required for rvsh script
#author		     : G. Mahfoudi & S. JUHEL
#date            : 20/05/2015
#version         : 0.1    
#bash_version    : 4.3.X(1)-release


#
#   faire la desinstallation
#

if [ "$(whoami)" != "root" ]
then
    
    echo "[ERROR] Persmission denied: you need to be root to perform this action"
     
else
    USERNAME="rvsh"
    
    
    echo -e "[*] running $(basename $0)...\n"
    echo "[*] enter a password for $USERNAME"
    pass=$(mkpasswd) 
     
    useradd --home /home/rvsh --uid 1010 --shell /bin/bash --password "$pass" $USERNAME  
    
    mkdir /home/rvsh
    chmod 777 /home/rvsh
      
    echo "[*] user: rvsh"
    echo "[*] uid : 1010"
    echo "[*] gid : 1010"
    echo "[*] home: /home/rvsh"
    echo "[*] shell:/bin/bash"
    
fi
