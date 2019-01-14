#!/bin/sh
wget https://install.direct/go.sh
bash go.sh
python3 user.py
cp config.json /etc/v2ray/config.json
systemctl start v2ray
