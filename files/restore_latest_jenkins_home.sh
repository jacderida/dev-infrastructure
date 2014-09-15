#!/usr/bin/env bash

jenkins_home_path="/var/lib/jenkins"
latest_backup_file=$(aws s3 ls s3://jacderida-jenkins-backups | sort | tail -n 1 | cut -d ' ' -f 5)

sudo service jenkins stop
aws s3 cp s3://jacderida-jenkins-backups/$latest_backup_file "/tmp/$latest_backup_file"
sudo su -l -s /bin/bash -c "rm -r ./* && tar xvf /tmp/$latest_backup_file -C $jenkins_home_path" jenkins
sudo service jenkins start
