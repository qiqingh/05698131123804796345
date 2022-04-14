
if test -z $1 ; then 
    echo "Usage: $0 <wan-interface>"
    exit 1
fi

echo "================================================="
echo "[34_qemu]: Going to kill 32 ... "
touch is_terminating_32.txt
rm is_running_32.txt

sleep_duration=$(cat sleep_duration_22.txt)
sleep_pids=`ps aux | grep sleep | grep -v grep | grep $sleep_duration | awk '{print$2}'`
for pid in $sleep_pids; do
    kill -9 $pid
done
sleep_duration=$(cat sleep_duration_23.txt)
sleep_pids=`ps aux | grep sleep | grep -v grep | grep $sleep_duration | awk '{print$2}'`
for pid in $sleep_pids; do
    kill -9 $pid
done

echo "[34_qemu]: Waiting for 22, 23, and 32 to be killed ..."
sleep 5

echo "[34_qemu]: Goiong to call ./33_clean_guest to kill QEMU ... "
./33_clean_guest.sh $1 192.168.1.1

echo "[34_qemu]: Done! please call ./93_check_what_is_alive.sh to check what is alive. "
echo "[34_qemu]: It may take up to 60 seconds to clean up ... "
echo "================================================="
