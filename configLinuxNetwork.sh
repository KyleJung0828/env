#!/bin/bash

promptDeviceName()
{
    read -p "Enter Network Device Name : " prompt
    if [ ${prompt} == "" ]; then
        echo "Wrong input. type <ifconfig -a> in command line to check your device name"
        exit 0
    fi

    DeviceName=${prompt}
}
    
promptNetworkInput()
{
    read -p "Enter Your IP Address : " prompt
    if [ ${prompt} == "" ]; then
        echo "Wrong input. Exiting..."
        exit 0
    fi

    IP=${prompt}

    read -p "Enter Your NetMask Address : " prompt
    if [ ${prompt} == "" ]; then
        echo "Wrong input. Exiting..."
        exit 0
    fi

    NetMask=${prompt}

    read -p "Enter Your Gateway Address : " prompt
    if [ ${prompt} == "" ]; then
        echo "Wrong input. Exiting..."
        exit 0
    fi

    Gateway=${prompt}
    
}

forceSudo()
{
    if [ "$(id -u)" -ne "0" ]; then
        echo -e "Permission denied. Use Sudo"
        exit 0
    fi
}

forceSudo

promptDeviceName

FileName=/etc/network/interfaces.d/${DeviceName}

if [ -e ${FileName} ]; then
    echo -e "Network setting file seems to exist already. Check /etc/network/interfaces.d/"
    exit 0
fi

promptNetworkInput

echo -e "\nCreating file ${FileName}"

echo "auto ${DeviceName}" >> ${FileName}
echo "iface ${DeviceName} inet static" >> ${FileName}
echo "    address ${IP}" >> ${FileName}
echo "    netmask ${NetMask}" >> ${FileName}
echo "    Gateway ${Gateway}" >> ${FileName}

echo -e "\n"

read -p "Network settings are done. Do you want to open the setting file? <y/n> " prompt
if [ ${prompt} == "y" ]; then
    sudo vi ${FileName}
fi

exit 0

