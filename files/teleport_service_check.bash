#!/usr/bin/env bash
TLOGF="/var/log/teleport/teleport.log"
TDATE=`date -d "1 hour ago" "+%Y-%m-%dT%H"`
TSTATUS=`systemctl status teleport|grep "active (running)"|wc -l`

ERRCOUNT1=`cat ${TLOGF}| grep "Failed to ping web proxy"|wc -l`
ERRCOUNT2=`cat ${TLOGF}| grep "No valid environment variables found."|wc -l`
ERRCOUNT=$(( ${ERRCOUNT1}+${ERRCOUNT2} ))

function rotate_teleport_log() {
	logrotate -vf /etc/logrotate.d/teleport
}

if [[ ${ERRCOUNT} -gt 0 ]]
then
  	echo "Teleport service errors detected: restart in progress"
    systemctl restart teleport
    rotate_teleport_log
    if [[ ${TSTATUS} -eq 0 ]]
    then
    	echo "Teleport service did not start!"
    fi
else 
  	echo "teleport service is ok restart is not needed"
fi
