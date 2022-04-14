# This script will destroy the whole screen session
# containing the qemu instance. Becareful to use. 
# Once called, the qemu instance will be killed 
# immediately. 

if test -z $2 ; then 
	echo "Usage: $0 <wan-interface> <guest IP>"
	echo "E.g., $0 eno1 192.168.1.1"
	exit 1
fi


screen_id=$(cat qemu_screen_id_04.txt)
echo "[33_qemu]: Killing the screen session: $screen_id ..."
screen -X -S $screen_id quit
# make sure it's killed 
screen -X quit
echo "[33_qemu]: Removing qemu_screen_id_04.txt ..."
rm qemu_screen_id_04.txt
echo "[33_qemu]: Resetting rsyslog ..."
cp /etc/rsyslog.conf.orig /etc/rsyslog.conf
systemctl restart rsyslog
echo "[33_qemu]: Recoving public IP (removing NAT rules) ..."
./14_recover_public_ip.sh "$1" "$2"
echo "[33_qemu]: Cleaning done!!"

