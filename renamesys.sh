#!/bin/bash



CUR_HOSTNAME=$(cat /etc/hostname)
NEW_HOSTNAME=$(lsblk --nodeps -no serial /dev/sda)


if [ $CUR_HOSTNAME == $NEW_HOSTNAME ] ; then

while true; do
sleep 1
done
#	echo "Sorry, you are already renamed."
#	exit 2
fi


if [ $CUR_HOSTNAME != $NEW_HOSTNAME ] ; then

# Display the current hostname
echo "The current hostname is $CUR_HOSTNAME"

# Change the hostname
hostnamectl set-hostname $NEW_HOSTNAME
hostname $NEW_HOSTNAME

# Change hostname in /etc/hosts & /etc/hostname
sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname

# Display new hostname
echo "The new hostname is $NEW_HOSTNAME"
while true; do
sleep 1
done
fi
