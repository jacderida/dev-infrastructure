#!/usr/bin/env bash

backup_location="jacderida-jenkins-backups"
jenkins_home_path="/var/lib/jenkins"
latest_backup_command="aws s3 ls s3://$backup_location | sort | tail -n 1 | cut -d ' ' -f 5"
latest_backup_file=$($latest_backup_command)
backup_url="https://$backup_locations3.amazonaws.com/$latest_backup_file"

service jenkins stop
aws s3 cp $backup_url "/tmp/$latest_backup_file"
sudo su -l -s /bin/bash -c "tar xvf /tmp/$latest_backup_file -C $jenkins_home_path" jenkins
service jenkins start
