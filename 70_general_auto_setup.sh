
if test -z $1 ; then
    echo "Usage: $0 <wan-interface>"
    echo "E.g, $0 eth0"
    exit 1
fi

echo "[71_qemu]: executing ./00_prepare_kernels.sh"
./00_prepare_kernels.sh 


echo "[71_qemu]: executing ./00_prepare_kernels.sh"
./01_install_dependencies.sh 
sleep 1


echo "[71_qemu]: executing ./02_setup_host_net.sh"
./02_setup_host_net.sh tap0 192.168.1.2 255.255.255.0
echo "[71_qemu]: waitng tap0 to be ready ... "
sleep 5


echo "[71_qemu]: executing ./03_setup_forwarding.sh"
./03_setup_forwarding.sh $1 tap0
sleep 3 

echo "[71_qemu]: executing ./07_block_outgoing_scanning.sh"
./07_block_outgoing_scanning.sh tap0
sleep 1


echo "[71_qemu]: executing ./15_replace_host_ssh.sh"
wan_ip=`ifconfig $1 | grep netmask | awk -F ' ' '{print$2}'`
./15_replace_host_ssh.sh 22323 $1 $wan_ip

echo " ================================= "
echo "/proc/sys/net/ipv4/ip_forward : "
echo ""

cat /proc/sys/net/ipv4/ip_forward 


./09_check_iptables.sh
exit 0 


#echo " ================================= "
#echo "iptables -vL"
#echo ""

#iptables -vL

#echo " ================================= "
#echo "iptables -t nat -vL"
#echo ""

#iptables -t nat -vL

#echo " ================================= "
