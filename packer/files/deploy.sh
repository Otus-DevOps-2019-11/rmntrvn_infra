#!/bin/bash

sudo apt install -y git
cd /home/rmntrvn && git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
