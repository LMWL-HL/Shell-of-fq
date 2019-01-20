import os
import json

load_f = open("config_vps.json","r",encoding="utf-8")
load_dict = json.load(load_f)
load_dict["inbounds"][0]["port"] = "?????"
print("你的端口："+load_dict["inbounds"][0]["settings"]["clients"][0]["id"])

load_f.close()

load_f = open("config_vps.json","w",encoding="utf-8")
json.dump(load_dict,load_f)

load_f.close()
