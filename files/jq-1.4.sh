#!/usr/bin/env bash

set -e

if [ ! -f "/usr/local/bin/jq" ]; then
    wget --output-document=/tmp/jq-1.4.tar.gz http://stedolan.github.io/jq/download/source/jq-1.4.tar.gz
    tar -xvf /tmp/jq-1.4.tar.gz -C /tmp
    present_directory=`pwd`
    cd /tmp/jq-1.4
    ./configure && make && make install
    cd $present_directory
    rm /tmp/jq-1.4.tar.gz
    rm -r -f /tmp/jq-1.4
fi
