# The first parameter is the name of the pcap file that you 
# used in 94 scripts. 


if test -z $1; then 
    echo "Warning: You are going to stop TCPDUMP !!  "
    echo "Usge: <$0> <any-thing-here>"
    exit 1
fi


pids=`ps aux | grep tcpdump | grep -v grep | awk '{print$2}'`

for pid in $pids; do 
    echo "[95_qemu] : Stopping tcpdump (pid=$pid) ... "
    kill -2 $pid
done

