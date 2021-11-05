#!/bin/bash

case "$1" in
start)

   CUR_HOSTNAME=$(cat /etc/hostname)
   NEW_HOSTNAME=$(lsblk --nodeps -no serial /dev/sda)
   TIMESTAMP=$`date "+%Y-%m-%d %H:%M:%S"`
   LOGFILE=$"/usr/bin/logfile.log"
   ip=$(sed -n 1p ./ftp.ini)
   user=$(sed -n 2p ./ftp.ini)
   pass=$(sed -n 3p ./ftp.ini)

   curl ftp://$ip --user "$user:$pass" -T $LOGFILE
   echo "$TIMESTAMP: Service start" > $LOGFILE

   # Check hostname and running service
   if [ $CUR_HOSTNAME == $NEW_HOSTNAME ] ; then
     echo "$TIMESTAMP: You are already renamed!" > $LOGFILE
     sudo bash /usr/bin/sas.sh selfremove
   fi


   if [ $CUR_HOSTNAME != $NEW_HOSTNAME ] ; then

   # Display the current hostname
   echo "$TIMESTAMP: The current hostname is $CUR_HOSTNAME" > $LOGFILE

   # Change the hostname
   hostnamectl set-hostname $NEW_HOSTNAME
   hostname $NEW_HOSTNAME

   # Change hostname in /etc/hosts & /etc/hostname
   sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
   sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname

   # Display new hostname
   echo "The new hostname is $NEW_HOSTNAME" > $LOGFILE
   bash /usr/bin/sas.sh selfremove
   fi

#   while true; do
#   sleep 1
#   done
   ;;
stop)
   kill `cat /var/run/sas.pid`
   rm /var/run/sas.pid
   ;;
restart)
   $0 stop
   $0 start
   ;;
selfremove)
    echo "$TIMESTAMP: Start selfremove..." > $LOGFILE
    $0 stop
    systemctl disable hostname.service
    rm /etc/systemd/system/hostname.service
    echo "$TIMESTAMP: Selfremove done" > $LOGFILE
    echo "$TIMESTAMP: Send info to FTP" > $LOGFILE
    curl ftp://$ip --user "$user:$pass" -T $LOGFILE
    rm /usr/bin/logfile.log
    rm /usr/bin/sas.sh
      ;;
status)
   if [ -e /var/run/renamesys.pid ]; then
      echo renamesys.sh is running, pid=`cat /var/run/renamesys.pid`
   else
      echo renamesys.sh is NOT running!
      exit 1
   fi
   ;;
*)
   echo "Usage: $0 {start|stop|status|restart|selfremove}"
esac

exit 0
