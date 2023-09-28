while read -r sg_id sg_name; do
    echo "$sg_id $sg_name"
    # Extract the rules for the security group in JSON format
    rules=$(aws ec2 describe-security-groups --group-ids "$sg_id" --region us-west-1 --query "SecurityGroups[0].IpPermissions" --output json)

    # Create a new security group in the destination region
    new_sg=$(aws ec2 create-security-group --group-name "$sg_name" --description "Copied SG" --region us-west-2 --query "GroupId" --output text)
    echo $new_sg

    # # Authorize the rules for the new security group
    aws ec2 authorize-security-group-ingress --group-id "$new_sg" --region us-west-2 --ip-permissions "$rules"
done < sgs.txt
