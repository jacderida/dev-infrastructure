#!/usr/bin/env bash

echo "Waiting for JIRA server to start (this will take several minutes)..."
jenkins_log_path="/home/jira/log/atlassian-jira.log"
sleep 30 # Give a little bit of time for to be created.
(tail -f $jenkins_log_path | grep -q "You can now access JIRA through your web browser.")
echo "JIRA server started!"
