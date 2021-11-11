#!/bin/bash

MASTER_IP=$1

ssh -S mongo-0-socket -O exit ec2-user@$MASTER_IP
ssh -S mongo-1-socket -O exit ec2-user@$MASTER_IP
ssh -S mongo-2-socket -O exit ec2-user@$MASTER_IP