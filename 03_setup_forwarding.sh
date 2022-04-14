#
# You must execute this script with ROOT. 
# 
if test -z $2 ; then 
	echo "Usage: $0 <wan-interface> <tap-name>"
	echo "E.g., $0 eth0, tap0"
	exit 1
fi


sudo iptables -t nat -A POSTROUTING -o "$1" -j MASQUERADE
sudo iptables -I FORWARD 1 -i "$2" -j ACCEPT
sudo iptables -I FORWARD 1 -o "$2" -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
sudo echo 1 > /proc/sys/net/ipv4/ip_forward


echo "YOU MUST MANUALLY TYPE THE FOLLOWING AS ROOT:"
echo "echo 1 > /proc/sys/net/ipv4/ip_forward"
echo "Use 'sudo iptables -t nat -vL' to check the rules"



