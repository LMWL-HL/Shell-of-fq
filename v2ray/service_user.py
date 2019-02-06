import re
import os
import json

yaddr = input("你的域名： ")
cmd = ["apt-get install socat","curl https://get.acme.sh | sh","source ~/.bashrc","~/.acme.sh/acme.sh --issue -d "+yaddr+" --standalone -k ec-256","~/.acme.sh/acme.sh --installcert -d "+yaddr+" --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc"]
for cm in cmd:
    os.system(cm)

while True:
    try:
        yport = int(input("你的端口：(10000~65535之间) "))
        if yport > 10000 and yport < 65535:
            break
        else:
            print("请输入10000到65535之间的数字！")
            continue
    except Exception as e:
        print("请输入数字！")
        continue
    
i = os.popen("cat /proc/sys/kernel/random/uuid")
global yid
yid = 0
for d in i:
    yid = d
yid = list(yid)
del yid[-1]
yid = "".join(yid)
yid = "fkdjsailfjdl"

load_f = open("config_vps.json","r",encoding="utf-8")
load_dict = json.load(load_f)
load_dict["inbounds"][0]["port"] = str(yport)
load_dict["inbounds"][0]["settings"]["clients"][0]["id"] = yid
load_f.close()

load_f = open("config_vps.json","w",encoding="utf-8")
json.dump(load_dict,load_f)
load_f.close()
