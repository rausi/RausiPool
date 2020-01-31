#!/bin/bash
#jormungandr node start and stuck monitoring

param="$1"
cat /dev/null > ./logs/stuckmonitor.out
#Kill jstartssh background process if running and script is started again
echo "*****Cardano stakepool starting script*****"
echo ">> Check status before start"
PID3=""
PID3=$(pgrep jstartssh.sh)
if [ -z $PID3 ]; then
 echo ">> no previous ssh script running - continue"
else
 echo ">> previous script runnig - kill jstartssh script"
 kill $PID3
 echo ">> DONE"
 echo "-------"
fi

if [ "$param" == "ssh" ] ; then
 echo ">> Starting SSH scrip at background"
 nohup ./jstartssh.sh > ./logs/stuckmonitor.out 2>&1 &
 echo ">> DONE"
 echo "-------"
 echo "NOTE! Check stuck monitor status by typing: tail -f ./logs/stuckmonitor.out"
 echo "NOTE! Check node status by typing: tail -f ./logs/node.out"
 echo "-------"
elif  [ "$param" == "ubuntu" ] ; then
 echo ">> Start GUI monitoring"
 ./jstartubuntu.sh 
else
  echo ">> Starting SSH scrip at background"
  nohup ./jstartssh.sh > ./logs/stuckmonitor.out 2>&1 &
  echo ">> DONE"
  echo "-------"
  echo "NOTE! Check monitor status by typing: tail -f ./logs/stuckmonitor.out"
  echo "NOTE! Check node status by typing: tail -f ./logs/node.out"
  echo "-------"
fi 
