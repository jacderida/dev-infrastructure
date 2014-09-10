#!/usr/bin/env bash

set -e

image_name=$(basename `pwd` | sed 's/aws-//g')

function get_instances()
{
    aws ec2 describe-instances --output json
}

function get_instance_public_dns()
{
    jq --raw-output --arg image_name $image_name '.[] | .[] | .Instances[] | [{ image_id: .InstanceId, name: .Tags[]["Value"], public_ip: .PublicDnsName }] | map(select(.name == $image_name)) | .[] | .public_ip'
}

vagrant up --provider=aws
sleep 5
public_dns=$(get_instances | get_instance_public_dns)
echo "Jenkins is running at http://$public_dns:8080"
