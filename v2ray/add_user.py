import json
import os

def add_usr()
    i = os.popen("cat /proc/sys/kernel/random/uuid")
    global yid
    yid = 0
    for d in i:
        yid = d
    yid = list(yid)
    del yid[-1]
    yid = "".join(yid)
    da = {"id": yid, "level": 1, "alterId": 64}

    load_f = open("/etc/v2ray/config.json","r",encoding="utf-8")
    load_dict = json.load(load_f)
    load_dict["inbounds"][0]["settings"]["clients"].append(da)
    load_f.close()

    load_f = open("/etc/v2ray/config.json","w",encoding="utf-8")
    json.dump(load_dict,load_f)
    load_f.close()

n = input("添加多少位用户：")

for i in range(n):
    add_usr()
