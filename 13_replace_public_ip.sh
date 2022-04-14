# Attention: once you executed this script, your host machine will 
# no longer accept new SSH connection.


if test -z $2 ; then 
	echo "Usage: $0 <wan-interface> <guest IP>"
	echo "Usage: $0 eth0 192.168.1.1"
	exit 1
fi



sudo iptables -t nat -A PREROUTING -i "$1" -j DNAT --to "$2"

echo "[13_qemu]: You can use 'iptables -t nat -vL' to check your rules"


