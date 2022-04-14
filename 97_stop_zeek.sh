


if test -z $1; then 
    echo "Warning: You are going to stop zeek !!  "
    echo "Usge: <$0> <any-thing-here>"
    exit 1
fi

pids=`ps aux | grep "/opt/zeek/bin/zeek" | grep -v grep | awk '{print$2}'`

for pid in $pids; do 
    echo "[97_qemu] : Stopping zeek (pid=$pid) ... "
    kill -9 $pid
done
