#!/bin/bash
#Config
#Define stuck_notifier poll time
POLL_TIME="10m"
#Define your yaml file
CONFIG_FILE="ubuntu-config.yaml"
#Define your secret file
SECRET_FILE="node_secret.yaml"
#Define your REST listen port
PORT=3100

echo "*****jstartubuntu script*****"
echo ">> Checking if old log file existing"
if [ -e ./logs/test.log ]
then
   echo ">> Clear old log files"
   echo ">> Remove error files (node.er*)"
   rm ./logs/test.er* 2> /dev/null
   cat /dev/null > ./logs/test.log
   #cat /dev/null > ./logs/node.out
   echo ">> DONE"
else
    echo ">> No old log files. Continue"
fi

PID2=""
#Kill jormungandr if running and script is started again
echo "-------"
echo ">> Checking if previous jormungandr running"
PID2=$(pidof -s jormungandr)
if [ -z $PID2 ]; then
 echo ">> jormungandr is not running - continue"
else
 echo ">> previous jormungandr is running - shutdown jormungandr"
 ./jcli rest v0 shutdown get --host "http://127.0.0.1:${PORT}/api"
 echo ">> DONE"
 echo "-------"
 echo ">> Checking if shutdown was ok"
 sleep 2s
 PID2=""
 PID2=$(pidof -s jormungandr)
   if [ -z $PID2 ]; then
    echo ">> jormungandr is not running - continue"
   else
    echo ">> jormungandr still running - kill jormungandr"
    kill $PID2
    echo ">> DONE"
    echo "-------"
   fi
fi

echo ">> If needed Stop script by pressing CTRL+C"
echo ">> Starting jormungandr node 1st time"
gnome-terminal --title="jormungandr running" --geometry=90x25 -- /bin/bash -c './jormungandr --genesis-block-hash $(cat genesis-hash.txt) --config ./"'${CONFIG_FILE}'" --secret ./"'${SECRET_FILE}'"'
restart=0
i=1

while :
do
 dt2=$(date '+%H:%M:%S %d/%m/%Y')
 echo "*** wait $POLL_TIME before stuck_notifier poll. Time:$dt2 ***"
 echo "-----"
 sleep $POLL_TIME
 echo ">> Checking jormungandr status"
 PID=""
 PID=$(pidof -s jormungandr)
 if [ -z $PID ]; then
   echo "!!!!! jormungandr not running !!!!!"
   echo ">> start jormungandr again"
   gnome-terminal --title="jormungandr running" --geometry=90x25 -- /bin/bash -c './jormungandr --genesis-block-hash $(cat genesis-hash.txt) --config ./"'${CONFIG_FILE}'" --secret ./"'${SECRET_FILE}'"'
  echo ">> DONE"
 else
   echo ">> jormungandr OK - continue"
 fi
 
 echo ">> check stuck_notifier from log file. No.time " $i
 grep -q 'stuck_notifier' ./logs/test.log
 if [ $? -eq 0 ] ; then
   dt=$(date '+%H:%M:%S %d/%m/%Y') 
   echo "!!!!! STUCK_NOTIFIER FOUND !!!!! Time:"$dt
   echo ">> stopping node"
   ./jcli rest v0 shutdown get --host "http://127.0.0.1:${PORT}/api"
   echo ">> clear log files"
   cp ./logs/test.log ./logs/test.er$i
   sleep 1s
   cat /dev/null > ./logs/test.log
   echo ">> DONE"
   sleep 3s
   restart=$((restart+1))
   echo ">> starting node again. No.time " $restart
   gnome-terminal --title="jormungandr running" --geometry=90x25 -- /bin/bash -c './jormungandr --genesis-block-hash $(cat genesis-hash.txt) --config ./"'${CONFIG_FILE}'" --secret ./"'${SECRET_FILE}'"'
 else
   echo ">> stuck_notifier not found. Continue node normally"
 fi
 
 if [ "$i" == "144" ] ; then
   echo ">> clear log files | every 144*$POLL_TIME"
   cat /dev/null > ./logs/stuckmonitor.out
   cat /dev/null > ./logs/test.log
   sleep 2s
   i=0
   echo ">> DONE"
 fi
 i=$(( i+1 ))
done
