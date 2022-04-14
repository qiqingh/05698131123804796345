
id_path=$(pwd)

if test ! -f "$id_path/current_honeypot_id.txt" ; then
	echo "current_honeypot_id.txt not found. Did you start your honeypot?"
	exit 1
fi

honeypot_id=$(cat current_honeypot_id.txt)

# Have already backed up
if test -f /etc/rsyslog.conf.orig ; then 
    echo "[06_qemu] : /etc/rsyslog.conf has already been backed up ... "
else
    echo "[06_qemu] : Backing up /etc/rsyslog.conf ... "
    cp /etc/rsyslog.conf /etc/rsyslog.conf.orig
fi

# Use the origianl one because you don't want to insert multiple times 
cp /etc/rsyslog.conf.orig /etc/rsyslog.conf

echo "[06_qemu] : Copying ./rsyslog.config to /etc/virtual_openwrt/rsyslog.config ... "
cp ./rsyslog.config /etc/virtual_openwrt_rsyslog.config

echo "[06_qemu] : Preparing /etc/virtual_openwrt_rsyslog.config ... "
echo '$template remote-incoming-logs, "/var/log/'$honeypot_id'/%HOSTNAME%/%PROGRAMNAME%.log"' >> /etc/virtual_openwrt_rsyslog.config
echo '*.* ?remote-incoming-logs' >> /etc/virtual_openwrt_rsyslog.config
mkdir -p /var/log/$honeypot_id
chgrp syslog /var/log/$honeypot_id
chmod 775 /var/log/$honeypot_id


echo "[06_qemu] : Patching /etc/rsyslog.conf ... "
sed -i '25 a $IncludeConfig /etc/virtual_openwrt_rsyslog.config' /etc/rsyslog.conf 


echo "[06_qemu] : Restarting rsyslog ... "
systemctl restart rsyslog 

echo "[06_qemu] : ------------------------------------------ "
echo "[06_qemu] : Current rsyslog is listening on the ports: "
netstat -4altunp | grep 51414

echo "[06_qemu] : ------------------------------------------ "
echo "[06_qemu] : Remember to backup old log files at /var/log/"$honeypot_id"/OpenWrt"

