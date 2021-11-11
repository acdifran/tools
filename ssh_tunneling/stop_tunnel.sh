#!/bin/bash

MASTER_IP=$1

ssh -S aries-socket -O exit ec2-user@$MASTER_IP
ssh -S cortex-socket -O exit ec2-user@$MASTER_IP
ssh -S um-socket -O exit ec2-user@$MASTER_IP
ssh -S gemini-socket -O exit ec2-user@$MASTER_IP
ssh -S remote-job-gateway-socket -O exit ec2-user@$MASTER_IP
