#!/usr/bin/python3.6
import os

cmd = ["wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh","chmod +x shadowsocksR.sh","./shadowsocksR.sh 2>&1 | tee shadowsocksR.log","cp shadowsocks.json /etc/shadowsocks.json","wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh","chmod +x bbr.sh","./bbr.sh"]

for cm in cmd:
	os.system(cm)
