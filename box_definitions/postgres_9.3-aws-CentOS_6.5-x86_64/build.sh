#!/usr/bin/env bash

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

function get_image_id_for_name_from_my_amis()
{
    get_self_owned_aws_images | get_image_id_for_name
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
        aws ec2 create-security-group --group-name $full_image_name --description "Postgres machine for development infrastructure"
        sleep 5
        echo "Authorizing port 22 on $full_image_name"
        group_id=$(get_group_id_from_image_name)
        open_port_on_security_group 22 $group_id
        open_port_on_security_group 5432 $group_id
    fi
}

function build_image()
{
    /usr/local/bin/packer build -var 'image_name='"$full_image_name"'' template.json
}

function replace_vagrant_image_id()
{
    sleep 5 # Sometimes AWS may need some time to catch up.
    local image_id=$(get_image_id_for_name_from_my_amis)
    echo "Updating Vagrantfile with new image ID $image_id"
    sed -i "s/aws.ami = \".*\"/aws.ami = \"$image_id\"/g" ../../provisioning/postgres_9.3-aws-CentOS_6.5-x86_64/Vagrantfile
}

echo "Building box $full_image_name"
remove_existing_image
create_security_group
build_image
replace_vagrant_image_id
