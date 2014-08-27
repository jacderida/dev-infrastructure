#!/usr/bin/env bash

backups_path="/srv/backups"
backup_file="jira_home_$(date +%d%m%y%k%M%S).tar"
tar -cvf $backup_file /home/jira
mv $backup_file /srv/jira_backup
aws s3 cp $backups_path/$backup_file s3://jacderida-jira-backups/$backup_file
