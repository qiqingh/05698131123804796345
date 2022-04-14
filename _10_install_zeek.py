import os 

os.system("sudo apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev zlib1g-dev -y")
os.system("echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_18.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list")
os.system("sudo wget -nv https://download.opensuse.org/repositories/security:zeek/xUbuntu_18.04/Release.key -O '/etc/apt/trusted.gpg.d/security:zeek.asc'")
os.system("sudo apt update")
os.system("sudo apt install zeek -y")
os.system("echo 'zeek is installed in /opt/zeek/'")


