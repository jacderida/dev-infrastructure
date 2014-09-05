#!/usr/bin/env bash

chsh -s /bin/bash jenkins
echo "jenkins" | passwd jenkins --stdin
