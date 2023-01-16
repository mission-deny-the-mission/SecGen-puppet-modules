import requests
import socket
import os

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))
ip = (s.getsockname()[0])
s.close()

proxies = {
    "http": None,
    "https": None,
}

data = {"type":"setting","name":"telemetry.opt","value":"in"}
response = requests.post("http://localhost:8080/v2-beta/setting", json = data, proxies=proxies)
print(response)

null = None
false = False
data = {"id":"api.host","type":"activeSetting","baseType":"setting","name":"api.host","activeValue":null,"inDb":false,"source":null,"value":"http://" + ip + ":8080"}
response = requests.put("http://localhost:8080/v2-beta/settings/api.host", json=data, proxies=proxies)
print(response)

data = {"type":"registrationToken"}
response = requests.post("http://localhost:8080/v2-beta/projects/1a5/registrationtoken", json=data, proxies=proxies)
key = response.json()["uuid"]

os.system("docker run -d --restart=unless-stopped --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://{}:8080/v1/scripts/{}".format(ip, key))