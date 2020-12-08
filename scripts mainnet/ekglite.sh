#!/bin/bash
#####################
# RausiPool | RAUSI #
# rausipool.fi      #
#####################
#prerequisites
#####################
# install curl if missing: sudo apt install curl
# install jq if missing:  sudo apt install jq
###Config.json file settings###
# set "TraceBlockFetchDecisions": true #needed if you want see peers. otherwise not displayed.
# set "ViewMode": "SimpleView"
# set "hasEKG": 12788,
##############
#Script Config
##############
EKGPORT=12788 #use same port than set in config.json file
EKGIP=127.0.0.1
NODENAME="RausiPool node" #Your Relay or Block Producing node name
#Define status poll time in seconds. 30s or more is recommended because of stuck notifier.
POLL_TIME="1m"

###########
#Functions
###########
###################################################
#MAIN script start
###################################################
#counters
i=1
LAST_BLOCK=""
CURRETTIP=""

###start loop
#############
while :
do
 clear
 dt2=$(date '+%H:%M:%S %d/%m/%Y')

###Read block and kes status etc
###########################
 CURRETTIP=$(curl -sH "Accept: application/json" ${EKGIP}:${EKGPORT} |  jq '.cardano.node.ChainDB.metrics.blockNum.int | .val')
 UPTIME=$(curl -sH "Accept: application/json" ${EKGIP}:${EKGPORT} |  jq '.rts.gc.wall_ms | .val')
 SLOT=$(curl -sH "Accept: application/json" ${EKGIP}:${EKGPORT} |  jq '.cardano.node.ChainDB.metrics.slotNum.int | .val')
 EPOCH=$(curl -sH "Accept: application/json" ${EKGIP}:${EKGPORT} |  jq '.cardano.node.ChainDB.metrics.epoch.int | .val')
 TXS=$(curl -sH "Accept: application/json" ${EKGIP}:${EKGPORT} |  jq '.cardano.node.metrics.txsProcessedNum.int | .val')
 PEERS=$(curl -sH "Accept: application/json" ${EKGIP}:${EKGPORT} |  jq '.cardano.node.BlockFetchDecision.peers.connectedPeers_int | .val')

 KES=$(curl -sH "Accept: application/json" ${EKGIP}:${EKGPORT} |  jq '.cardano.node.Forge.metrics.currentKESPeriod.int | .val')
 REMAININGKES=$(curl -sH "Accept: application/json" ${EKGIP}:${EKGPORT} |  jq '.cardano.node.Forge.metrics.remainingKESPeriods.int | .val') 
 BLOCKS=$(curl -sH "Accept: application/json" ${EKGIP}:${EKGPORT} |  jq '.cardano.node.metrics.Forge.forged.int | .val')
 UPTIME=$(echo "scale=2;${UPTIME}/1000/60/60" | bc)
###display block and kes status etc
###########################
 echo "*********************  EKGLite  ******************************"
 echo "--------------------------------------------------------------"
 echo "* $NODENAME status. Poll No.time " $i
 echo "--------------------------------------------------------------"
 echo "* EPOCH        : ${EPOCH}"
 echo "* BLOCK HEIGHT : ${CURRETTIP}"
 echo "* SLOT         : ${SLOT}"
 echo "* UPTIME HOURS : ${UPTIME}"
 echo "* TXs          : ${TXS}"
 if [ "$PEERS" != "null" ] ; then
  echo "* PEERS        : ${PEERS}"
 fi
 if [ "$KES" != "null" ] ; then
  echo "* KES          : ${KES}"
  echo "* REMAINING KES: ${REMAININGKES}"
  echo "* BLOCKS       : ${BLOCKS}"
 fi
 echo "--------------------------------------------------------------"
###Check node block status
###############################
 if [ "$CURRETTIP" > 0 ] ; then
  if [ "$CURRETTIP" = "$LAST_BLOCK" ] ; then
   echo "* $NODENAME Old block height: ${LAST_BLOCK}"
   echo "* $NODENAME New block height: ${CURRETTIP}"
   echo -e "\e[31m!!!!$NODENAME Stuck Stuck.!!!!!\e[0m"
  fi   
  if [ "$CURRETTIP" \> "$LAST_BLOCK" ] ; then
   echo "* $NODENAME Old block height: ${LAST_BLOCK}"
   echo "* $NODENAME New block height: ${CURRETTIP}"
  LAST_BLOCK="$CURRETTIP"          
  fi
 else
  echo "* No $NODENAME block height"
 fi
 echo "--------------------------------------------------------------"
 echo "* WAIT $POLL_TIME before next status poll. Time:${dt2} *"
 echo "* EXIT: <CTRL>+<C>                                          *" 
 echo "--------------------------------------------------------------" 
 sleep $POLL_TIME
 i=$(( i+1 ))
done
