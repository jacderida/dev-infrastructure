#!/usr/bin/env bash

image_name=$(basename `pwd`)
function get_self_owned_aws_images()
{
    aws ec2 describe-images --owners self --output json
}

function get_image_id_for_name()
{
    jq --raw-output --arg image_name $image_name '.Images | map(select(.Name == $image_name)) | .[]["ImageId"]'
}

function remove_existing_image()
{
    image_id=$(get_self_owned_aws_images | get_image_id_for_name)
    if [[ ! -z "$image_id" ]]; then
        echo "Removing existing $image_name AMI"
        aws ec2 deregister-image --image-id $image_id
    fi
}

remove_existing_image
packer build template.json
