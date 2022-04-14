

if test -z $1 ; then 
    echo "Usage: $0 <tap-name>"
    echo "E.g., $0 tap0"
    exit 1
fi

iptables -I FORWARD -i $1 -s 192.168.1.1/32 -p tcp --dport 23 -j DROP
iptables -I FORWARD -i $1 -s 192.168.1.1/32 -p tcp --dport 2323 -j DROP
iptables -I FORWARD -i $1 -s 192.168.1.1/32 -p tcp --dport 22 -j DROP
