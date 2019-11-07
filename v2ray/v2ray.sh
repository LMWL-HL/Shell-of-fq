#!/bin/sh
wget https://install.direct/go.sh
bash go.sh
echo 输入你的域名：
read host
apt install socat
curl https://get.acme.sh | sh
source ~/.bashrc
~/.acme.sh/acme.sh --issue -d $host --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $host --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc
uuid=`cat /proc/sys/kernel/random/uuid`
sed -i "s/HostReplace/$host/g" config.json
sed -i "s/IdReplace/$uuid/g" config_vps.json
sed -i "s/IdReplace/$uuid/g" config.json
cp config_vps.json /etc/v2ray/config.json
systemctl start v2ray
bbr_install=`lsmod | grep bbr`
just=`expr index $bbr_install "tcp_bbr"`
if [ $just -ne 0 ];then
  echo deployed
else
  wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
  chmod +x bbr.sh
  ./bbr.sh
fi
