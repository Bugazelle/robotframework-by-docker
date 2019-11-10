#!/usr/bin/env bash

set -xe

echo "Install pip3, requirements..."
apt-get install -y python3-distutils
curl -Lk https://bootstrap.pypa.io/get-pip.py | python3 -
pip3 install -r requirements.txt
# Rename pybot, rebot, robot, pabot
mv /usr/local/bin/robot /usr/local/bin/robot3
mv /usr/local/bin/rebot /usr/local/bin/rebot3
mv /usr/local/bin/pabot /usr/local/bin/pabot3
