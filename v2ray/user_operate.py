import json
import os

def add_usr(n)
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
    print("新加的第%d位用户信息：" % (n+1))
    print("\tid:\0" + yid)
    print("\tport:\0" + str(load_dict["inbounds"][0]["port"]))
    print("\tprotocol:\0" + str(load_dict["inbounds"][0]["protocol"]))
    print("\tlevel:\0" + str(load_dict["inbounds"][0]["settings"]["client"][0]["level"]))
    print("\talterId:\0" + str(load_dict["inbounds"][0]["settings"]["client"][0]["alterId"]))

def remove_user(dic):
    load_f = open("/etc/v2ray/config.json","r",encoding="utf-8")
    load_dict = json.load(load_f)
    if sorted(dic)[0]-1 <= load_dict["inbounds"][0]["settings"]["clients"]:
        load_f.close()
    else:
        return "超出用户数量范围！"
    for i in dic:
        load_f = open("/etc/v2ray/config.json","r",encoding="utf-8")
        load_dict = json.load(load_f)
        del load_dict["inbounds"][0]["settings"]["clients"][str(i)]
        load_f.close()

        load_f = open("/etc/v2ray/config.json","r",encoding="utf-8")
        json.dump(load_dict,load_f)
        load_f.close()
        print("已删除用户：")
        print("\tid:\0" + str(load_dict["inbounds"][0]["settings"]["client"][0]["id"]))
        return "Done!"

while True:
    try:
        op = int(input("进行什么操作：1、添加用户；2、删除用户"))
        if str(op) not in ["1","2"]:
            print("请输入1或2！")
            continue
        else:
            break
    except Exception as e:
        print("请输入数字！")

if op == 1:
    n = input("添加多少位用户：")

    for i in range(n):
        add_usr(i)
else:
    l = input("要删除那些用户（如1，2，3）：\0")
    li = l.split(",")
    for i in li:
        try:
            test = int(i)
        except Exception as e:
            print("请输入数字！")
    print(remove_user(li))
