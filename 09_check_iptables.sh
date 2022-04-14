

echo "------------ FORWARDING ------------"
echo ""
iptables -vL FORWARD 
echo ""
echo "------------ NAT PREROUTING ------------"
echo ""
iptables -t nat -vL PREROUTING
echo ""
echo "------------ NAT POSTROUTING ------------"
echo ""
iptables -t nat -vL POSTROUTING
echo ""
echo "-----------------------------------------"
