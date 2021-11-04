#!/bin/bash

case "$1" in
start)
   /usr/bin/renamesys.sh &
   echo $!>/var/run/renamesys.pid
   ;;
stop)
   kill `cat /var/run/renamesys.pid`
   rm /var/run/renamesys.pid
   ;;
restart)
   $0 stop
   $0 start
   ;;
selfremove)
    $0 stop
    systemctl disable hostname.service
    rm /usr/bin/renamesys.sh
    rm /etc/systemd/system/hostname.service
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
