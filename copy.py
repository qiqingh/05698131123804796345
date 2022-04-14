import os 


fileName = []
with open("./process.txt") as readFile:
	for line in readFile:
		line = line.strip()
		if(line not in fileName):
			fileName.append(line)

for name in fileName:
	os.system("cp -r /home/qiqingh/Desktop/virtual-honeypot/virtual_openwrt/" + name + " /home/qiqingh/Desktop/virtual-honeypot/simplifiedVirtualWrt/" + name)
