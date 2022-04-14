

if test -z $3 ; then
	echo "Usage: $0 <tap-name> <tap-IP> <tap-mask>"
	echo "E.g., $0 tap0 192.168.1.2 255.255.255.0"
	exit 1
fi

user_name=`whoami`
sudo tunctl -u "$user_name" -t "$1"
sudo ifconfig "$1" "$2" netmask "$3" up
ifconfig "$1"
