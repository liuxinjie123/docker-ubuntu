#!/bin/bash

if ! which wget > /dev/null; then
  echo "开始安装wget...";
  brew install wget;  
fi

if [[ ! -f node-v6.2.0-linux-x64.tar.gz ]]; then
    wget https://nodejs.org/dist/v6.2.0/node-v6.2.0-linux-x64.tar.gz
fi
