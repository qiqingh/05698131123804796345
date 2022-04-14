# The wan-interface and guest IP must match those 
# used in 06_replace_public_ip.sh

if test -z $2 ; then 
	echo "Usage: $0 <wan-interface> <guest IP>"
	echo "Usage: $0 eth0 192.168.1.1"
	exit 1
fi



sudo iptables -t nat -D PREROUTING -i "$1" -j DNAT --to "$2"

echo "[14_qemu]: You can use 'iptables -t nat -vL' to check your rules"


