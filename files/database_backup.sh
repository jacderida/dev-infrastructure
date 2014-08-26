#!/usr/bin/env bash

backups_path="/srv/backups"
pg_dump -U postgres jira > "$backups_path/jira_$(date +%d%m%y%k%M%S)"
backup_file=$(basename `ls $backups_path -t | head -n 1`)
aws s3 cp $backups_path/$backup_file s3://jacderida-postgres-backups/$backup_file
