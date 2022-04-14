# This script helps you setup an NAT rule so that you can reuse
# your public IP address for both your HOST and virtual devices. 
# It will keep your host's SSH alive when you redirect all 
# traffic to the guest virtual device. 
#
# You can specify a customized port number, e.g., 22323 to be
# mapped to the host's 22 port. 
#


if test -z $3 ; then 
	echo "Usage: $0 <new-port> <wan-interface>  <wan-interface-ip>"
	echo "E.g., $0 22323 ens4 10.150.0.5"
	echo "Note that <wan-interface-ip> is not the public IP. Instead, it's the IP of your wan-interface"
	echo "It is usually a private IP"
	exit 1
fi



sudo iptables -t nat -I PREROUTING -p tcp --dport "$1" -i "$2" -j DNAT --to "$3":22


echo "[15_qemu]: You can use 'iptables -t nat -vL' to check your rules"

