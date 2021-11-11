#!/bin/bash

TEMP=`getopt -o i:k:u: --long instance-id:,key:,user: -n 'Scale Down' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

ssh_pub_key_path_or_name="id_rsa"
ssh_user="ec2-user"

while true; do
  case "$1" in
    -i | --instance-id ) instance_id="$2"; shift 2;;
    -k | --key ) ssh_pub_key_path_or_name="$2"; shift 2;;
    -u | --user ) ssh_user="$2"; shift 2;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ -z "$instance_id" ];then
  echo "Must provide an instance id"
  exit 1
fi

ssh_authkeys='.ssh/authorized_keys'
ssh_pub_key_name=$(basename $ssh_pub_key_path_or_name)
ssh_pub_key_default_filepath="$HOME/.ssh/$ssh_pub_key_name.pub"

if [ -f "$ssh_pub_key_default_filepath" ];then
  ssh_pub_key=$(cat "$ssh_pub_key_default_filepath")
elif [ -f "$ssh_pub_key_path_or_name" ];then
  ssh_pub_key=$(cat "$ssh_pub_key_path_or_name")
else
  echo "No such key '$ssh_pub_key_path_or_name' found!"
  exit 1
fi

ssm_cmd=$(cat <<EOF
  "u=\$(getent passwd ${ssh_user}) && x=\$(echo \$u |cut -d: -f6) || exit 1
  install -d -m700 -o ${ssh_user} \${x}/.ssh; grep '${ssh_pub_key}' \${x}/${ssh_authkeys} && exit 1
  echo '${ssh_pub_key}' >> \${x}/${ssh_authkeys}"
EOF
  )

aws ssm send-command \
    --instance-ids "$instance_id" \
    --document-name "AWS-RunShellScript" \
    --parameters commands="${ssm_cmd}" \
    --comment "add public ssh key"

