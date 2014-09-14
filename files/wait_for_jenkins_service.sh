#!/usr/bin/env bash

jenkins_log_path="/var/log/jenkins/jenkins.log"
sleep 5 # Give a little bit of time for jenkins.log to be created.
(tail -f $jenkins_log_path | grep -q "INFO: Jenkins is fully up and running")
