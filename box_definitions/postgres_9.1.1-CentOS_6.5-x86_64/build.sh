#!/usr/bin/env bash

prefix="dev_infra-"
image_name=$(basename `pwd`)
full_image_name=$prefix$image_name

function get_self_owned_aws_images()
{
    aws ec2 describe-images --owners self --output json
}

function get_image_id_for_name()
{
    jq --raw-output --arg image_name $full_image_name '.Images | map(select(.Name == $image_name)) | .[]["ImageId"]'
}

function remove_existing_image()
{
    image_id=$(get_self_owned_aws_images | get_image_id_for_name)
    if [[ ! -z "$image_id" ]]; then
        echo "Removing existing $full_image_name AMI"
        aws ec2 deregister-image --image-id $full_image_name
    fi
}

function create_security_group()
{
    group_id=$(aws ec2 describe-security-groups | jq --raw-output --arg image_name $full_image_name '.SecurityGroups | map(select(.GroupName == $image_name)) | .[]["GroupId"]')
    if [[ -z "$group_id" ]]; then
        echo "Adding security group $full_image_name"
        aws ec2 create-security-group --group-name $full_image_name --description "Postgres machine for development infrastructure"
    fi
}

remove_existing_image
create_security_group
packer build template.json
