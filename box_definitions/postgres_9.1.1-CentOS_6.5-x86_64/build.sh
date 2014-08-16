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
    if [[ ! -z "$full_image_name" ]]; then
        echo "Removing existing $full_image_name AMI"
        aws ec2 deregister-image --image-id $full_image_name
    fi
}

remove_existing_image
packer build template.json
