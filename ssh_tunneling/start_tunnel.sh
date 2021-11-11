#!/bin/bash
 
USER=$1
IP=$2
SRC_PORT=$3
DEST_PORT=$4
NAME=$5

ssh -M -S $NAME-socket -fnNT -L $SRC_PORT:cortex-api-rest.marathon.l4lb.thisdcos.directory:$DEST_PORT $USER@$IP
