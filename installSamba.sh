#!/bin/bash

promptConfirmInformation()
{
    read -p "Is this information correct? <y/n> : " prompt
    if [ ${prompt} == y ]; then
        return
    elif [ ${prompt} == n ]; then
        promptUserName
    else
        echo -e "Enter y/n. Retrying..."
        promptConfirmInformation
    fi
}

promptUserName()
{
    read -p "Enter User Name for Samba : " prompt
    USER=${prompt}
    echo -e "You have entered : ${USER}" 

    promptConfirmInformation
}

forceSudo()
{
    if [ "$(id -u)" -ne "0" ]; then
        echo -e "Permission denied. Use sudo"
        exit 0
    fi
}

forceSudo

if grep -q ${USER} /etc/samba/smb.conf; then
    echo -e "Samba seems to be installed already. Check again."
    exit 0;
fi

promptUserName

sudo apt-get update

echo -e "Installing samba..."
sudo apt-get install samba

echo "[${USER}]" >> /etc/samba/smb.conf
echo "  comment = samba directory" >> /etc/samba/smb.conf
echo "  path = /home/${USER}/" >> /etc/samba/smb.conf
echo "  valid users = ${USER}" >> /etc/samba/smb.conf
echo "  public = yes" >> /etc/samba/smb.conf
echo "  writable = yes" >> /etc/samba/smb.conf
echo "  force users = ${USER}" >> /etc/samba/smb.conf

echo -e "Setting Samba Password..."
sudo smbpasswd -a ${USER}

echo -e "Restarting smbd service..."
sudo service smbd restart

