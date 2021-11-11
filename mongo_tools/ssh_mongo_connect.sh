#!/bin/bash

MASTER_IP=$1

ssh -M -S mongo-0-socket -fnNT -L 27017:mongo-rs-0-mongod.percona-server-mongodb.autoip.dcos.thisdcos.directory:27017 ec2-user@$MASTER_IP
ssh -M -S mongo-1-socket -fnNT -L 27018:mongo-rs-1-mongod.percona-server-mongodb.autoip.dcos.thisdcos.directory:27017 ec2-user@$MASTER_IP
ssh -M -S mongo-2-socket -fnNT -L 27019:mongo-rs-2-mongod.percona-server-mongodb.autoip.dcos.thisdcos.directory:27017 ec2-user@$MASTER_IP