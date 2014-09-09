#!/usr/bin/env bash

git_email_address=$1
git_real_name=$2
prefix="dev_infra-"
image_name=$(basename `pwd` | sed 's/aws-//g')
full_image_name=$prefix$image_name

function get_self_owned_aws_images()
{
    aws ec2 describe-images --owners self --output json
}

function get_image_id_for_name()
{
    jq --raw-output --arg image_name $full_image_name '.Images | map(select(.Name == $image_name)) | .[]["ImageId"]'
}

function get_group_id_from_image_name()
{
    aws ec2 describe-security-groups | jq --raw-output --arg image_name $full_image_name '.SecurityGroups | map(select(.GroupName == $image_name)) | .[]["GroupId"]'
}

function remove_existing_image()
{
    local image_id=$(get_self_owned_aws_images | get_image_id_for_name)
    if [[ ! -z "$image_id" ]]; then
        echo "Removing existing $full_image_name AMI"
        aws ec2 deregister-image --image-id $image_id
    fi
}

function open_port_on_security_group()
{
    local port=$1
    local group_id=$2
    echo "Authorizing port $port on $group_id"
    aws ec2 authorize-security-group-ingress --group-id $group_id --protocol tcp --port $port --cidr 0.0.0.0/0
}

function create_security_group()
{
    local group_id=$(get_group_id_from_image_name)
    if [[ -z "$group_id" ]]; then
        echo "Adding security group $full_image_name"
        aws ec2 create-security-group --group-name $full_image_name --description "AWS image builder slave for development infrastructure"
        sleep 5
        group_id=$(get_group_id_from_image_name)
        open_port_on_security_group 22 $group_id
    fi
}

echo "Building box $full_image_name"
remove_existing_image
create_security_group
/usr/bin/local/packer build -var 'image_name='"$full_image_name"'' -var 'git_email_address='"$git_email_address"'' -var 'git_real_name='"$git_real_name"'' template.json
