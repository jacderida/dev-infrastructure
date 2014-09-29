#!/usr/bin/env bash

latest_backup_file=$(aws s3 ls s3://jacderida-postgres-backups | sort | tail -n 1 | cut -d ' ' -f 8)
aws s3 cp s3://jacderida-postgres-backups/$latest_backup_file "/tmp/$latest_backup_file"
/usr/bin/psql -U postgres jira < /tmp/$latest_backup_file
