#!/usr/bin/env bash

set -xe

echo "Clear cache..."
apt-get -y clean all
rm -rf /headless/.cache
rm -rf .cache
rm -rf /var/log
rm -rf /tmp/*
rm -rf /var/lib/apt/lists/*

mkdir $HOME/ta.default/
mv $HOME/prefs.js $HOME/ta.default/
