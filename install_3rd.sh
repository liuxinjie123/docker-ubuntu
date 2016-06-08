#!/bin/bash

cd /opt;

if [[ ! -d node-v6.2.0-linux-x64 ]]; then
    wget https://nodejs.org/dist/v6.2.0/node-v6.2.0-linux-x64.tar.gz;
	tar -zxf node-v6.2.0-linux-x64.tar.gz;
    ln -s node-v6.2.0-linux-x64 node;
fi

