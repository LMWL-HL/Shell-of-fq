#!/bin/bash

# read info.
echo "输入你的域名："
read HOST
UUID=`cat /proc/sys/kernel/random/uuid`
PORT=$((RANDOM + 1024))

# v2ray install
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
if [[ $? != 0 ]]; then
  echo "v2ray install failed!"
  exit 1
fi

# install cert file.
apt install certbot
certbot certonly --standalone --agree-tos --email lmwl2hl@gmail.com --no-eff-email --domains $HOST
if [[ $? != 0 ]]; then
  echo "证书安装失败!"
  exit 1;
fi
install -d -o root -g root /etc/ssl/v2ray/
install -m 644 -o root -g root /etc/letsencrypt/live/$HOST/fullchain.pem -t /etc/ssl/v2ray/
install -m 644 -o root -g root /etc/letsencrypt/live/$HOST/privkey.pem -t /etc/ssl/v2ray/
cat > /etc/letsencrypt/renewal-hooks/deploy/v2ray.sh << EOF
#!/bin/bash

V2RAY_DOMAIN='$HOST'

if [[ "\$RENEWED_LINEAGE" == "/etc/letsencrypt/live/\$V2RAY_DOMAIN" ]]; then
    install -m 644 -o root -g root "/etc/letsencrypt/live/\$V2RAY_DOMAIN/fullchain.pem" -t /etc/ssl/v2ray/
    install -m 644 -o root -g root "/etc/letsencrypt/live/\$V2RAY_DOMAIN/privkey.pem" -t /etc/ssl/v2ray/

    sleep "\$((RANDOM % 2048))"
    systemctl restart v2ray.service
fi
EOF
chmod +x /etc/letsencrypt/renewal-hooks/deploy/v2ray.sh

# modify client.json and server.json
sed -i "s/HostReplace/$HOST/g" client.json
sed -i "s/\"PortReplace\"/$PORT/g" client.json
sed -i "s/IdReplace/$UUID/g" client.json

sed -i "s/HostReplace/$HOST/g" server.json
sed -i "s/\"PortReplace\"/$PROT/g" server.json
sed -i "s/IdReplace/$UUID/g" server.json
cp server.json /usr/local/etc/v2ray/config.json

# check bbr installed or not.
lsmod | grep bbr > /dev/null
if [[ $? != 0 ]]; then
  bash <(wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh)
else
  echo "bbr installed!"
fi

# start v2ray.service
systemctl enable v2ray.service
systemctl start v2ray.service
