import re

with open("/etc/v2ray/config.json","r") as load_f:
    load_dict = json.load(load_f)
    print("你的端口："+load_dict["inbounds"][0]["port"])
    print("你的id："+load_dict["inbounds"][0]["settings"]["clients"][0]["id"])
    
    
