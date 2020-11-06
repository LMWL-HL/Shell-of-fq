#!/bin/bash

UUID=`cat /proc/sys/kernel/random/uuid`
PORT=$((RANDOM + 1024))
BBRURL="https://github.com/teddysun/across/raw/master/bbr.sh"
V2RAYURL="https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh"
CERTPATH="/etc/letsencrypt/live/"
V2RAYCERTPATH="/etc/ssl/v2ray/"
SHCONTENT="#!/bin/bash\n\nV2RAY_DOMAIN='$HOST'\n\nif [[ \"\$RENEWED_LINEAGE\" == \"$CERTPATH/\$V2RAY_DOMAIN\" ]]; then\n\tinstall -m 644 -o root -g root \"$CERTPATH/\$V2RAY_DOMAIN/fullchain.pem\" -t $V2RAYCERTPATH\n\tinstall -m 644 -o root -g root \"$CERTPATH/\$V2RAY_DOMAIN/privkey.pem\" -t $V2RAYCERTPATH\n\n\tsleep \"\$((RANDOM % 2048))\"\n\tsystemctl restart v2ray.service\nfi\n"

# read info.
read_info(){
    echo "输入你的域名："
    read HOST
}

# v2ray install
install_v2ray(){
    bash <(curl -L $V2RAYURL)
    if [[ $? != 0 ]]; then
        echo "v2ray install failed!"
        exit 1
    fi
}

# install cert file.
install_cert_file(){
    apt install certbot
    certbot certonly --standalone --agree-tos --email yourmail@gmail.com --no-eff-email --domains $HOST
    if [[ $? != 0 ]]; then
        echo "证书安装失败!"
        exit 1;
    fi
    install -d -o root -g root $V2RAYCERTPATH
    install -m 644 -o root -g root $CERTPATH/$HOST/fullchain.pem -t $V2RAYCERTPATH
    install -m 644 -o root -g root $CERTPATH/$HOST/privkey.pem -t $V2RAYCERTPATH
    cp deploy.sh /etc/letsencrypt/renewal-hooks/deploy/v2ray.sh
    echo -e $SHCONTENT > /etc/letsencrypt/renewal-hooks/deploy/v2ray.sh
    chmod +x /etc/letsencrypt/renewal-hooks/deploy/v2ray.sh
}

# modify client.json and server.json
modify_config(){
    sed -i "s/HostReplace/$HOST/g" client.json
    sed -i "s/\"PortReplace\"/$PORT/g" client.json
    sed -i "s/IdReplace/$UUID/g" client.json

    sed -i "s/HostReplace/$HOST/g" server.json
    sed -i "s/\"PortReplace\"/$PORT/g" server.json
    sed -i "s/IdReplace/$UUID/g" server.json
    cp server.json /usr/local/etc/v2ray/config.json
}

# check bbr installed or not.
check_and_install_bbr(){
    lsmod | grep bbr > /dev/null
    if [[ $? != 0 ]]; then
        bash <(wget --no-check-certificate $BBRURL)
    else
        echo "bbr already installed!"
    fi
}

# start v2ray.service
start_v2ray(){
    systemctl enable v2ray.service
    systemctl start v2ray.service
}

print_config(){
    echo "服务器地址: $HOST"
    echo "端口(port): $PORT"
    echo "用户ID: $UUID"
    echo "额外id: 64"
    echo "加密方式: auto"
    echo "传输协议: ws"
    echo "伪装协议: none"
    echo "底层传输安全: tls"
}

main(){
    read_info
    install_v2ray
    install_cert_file
    modify_config
    check_and_install_bbr
    start_v2ray
}

main "$@"
