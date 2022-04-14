

if test -z $1 ; then 
    echo "Usage: $0 <wan-interface>"
    exit 1
fi



echo "[52_qemu]: Going to kill 51 ... "
rm is_running_51.txt

sleep_duration=$(cat sleep_duration_51.txt)
sleep_pids=`ps aux | grep sleep | grep -v grep | grep $sleep_duration | awk '{print$2}'`
for pid in $sleep_pids; do
    kill -9 $pid
done

echo "[52_qemu]: Waiting for 51 to be killed ..."
sleep 1

# Kill 32 gracefully. 
./34_kill_32_gracefully.sh $1 
sleep 1

## Kill tcpdump 
./95_stop_tcpdump_with_name.sh 1
sleep 1

## Kill zeek 
./97_stop_zeek.sh 1
sleep 1

echo "[52_qemu]: You may call watch -n 1 ./93_check_what_is_alive.sh "

watch -n 1 ./93_check_what_is_alive.sh

