# Use 95 to kill tcpdump. 
# Or use kill -2 pid to kill. 

if test -z $2 ; then 
    echo "Usage: $0 <path-to-save-pcap> <NIC you want to listen>"
    exit 1
fi 

mkdir -p $1
chmod 775 $1 
file_name="external.pcap"
echo $file_name > pcap_file_name_94.txt
echo "[94_qemu] : Going to start tcpdump ... "
nohup tcpdump -i $2 -U -C 45 -W 99 '! host 192.168.1.2' -w "$1/$file_name" > tcpdump_nohup 2>&1 &
