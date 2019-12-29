#!/bin/bash
echo "Checking if old log file existing"
if [ -e ./logs/test.log ]
then
    echo "Old log file found. Remove old log file"
    rm ./logs/test.log
else
    echo "No old log file. Continue"
fi
echo "*****Stop script by pressing ctrl+c*****"
echo "**Starting node 1st time**"
gnome-terminal --title="jormungandr running" --geometry=90x25 -- /bin/bash -c './jormungandr --genesis-block-hash $(cat genesis-hash.txt) --config ./itn_rewards_v1-config.yaml --secret ./node_secret.yaml'
restart=0
i=1
#loop check 720times = 720*10min=7200min=120h=5d
until [ $i -gt 720 ]
do
 echo "**wait 10min**"
 sleep 10m
 echo "check log file. No.time " $i
 grep -q 'stuck_notifier' ./logs/test.log
 if [ $? -eq 0 ] ; then
   echo ">>>>>STUCK_NOTIFIER FOUND<<<<<<"
   echo "stopping node"
   ./jcli rest v0 shutdown get --host "http://127.0.0.1:3100/api"
   echo "remove log file"
   rm ./logs/test.log
   sleep 2s
   restart=$((restart+1))
   echo "starting node again. No.time " $restart
   gnome-terminal --title="jormungandr running" --geometry=90x25 -- /bin/bash -c './jormungandr --genesis-block-hash $(cat genesis-hash.txt) --config ./itn_rewards_v1-config.yaml --secret ./node_secret.yaml'
 else
   echo "stuck_notifier not found. Continue node normally"
 fi
 i=$(( i+1 ))
done
