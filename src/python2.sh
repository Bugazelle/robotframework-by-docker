#!/usr/bin/env bash

set -xe

echo "Install pip2, requirements for python 2..."
curl -Lk https://bootstrap.pypa.io/get-pip.py | python -
pip install -r requirements.txt
# Rename pybot, rebot, robot, pabot
cp /usr/local/bin/robot /usr/local/bin/robot2
cp /usr/local/bin/rebot /usr/local/bin/rebot2
cp /usr/local/bin/pabot /usr/local/bin/pabot2
