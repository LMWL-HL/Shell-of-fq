import re
import os

yaddr = input("你的域名： ")
cmd = ["apt-get install socat","curl https://get.acme.sh | sh","source ~/.bashrc","~/.acme.sh/acme.sh --issue -d "+yaddr+" --standalone -k ec-256","~/.acme.sh/acme.sh --installcert -d "+yaddr+" --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc"]
for cm in cmd:
    os.system(cm)

f1 = open("config_vps.json")
l1 = f1.read()
f1.close()

l2 = l1.split("\n")
l3 = l1.split("\n")

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
    
yid = input("你的id：")

for i in l2:
    if re.search("\?+",i) is not None:
        if re.search("port",i) is not None:
            ind = l2.index(i)
            del l3[ind]
            l3.insert(ind,"    \t\t\"port\": "+str(yport)+",")
        if re.search("id",i) is not None:
            ind = l2.index(i)
            del l3[ind]
            l3.insert(ind,"          \t\t\t\t\t\"id\": \""+yid+"\",")

l4 = "\n".join(l3)
f2 = open("config.json","w",encoding="utf-8")
f2.write(l4)
f2.close()
