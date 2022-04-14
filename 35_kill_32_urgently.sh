
if test -z $1 ; then 
    echo "Usage: $0 <wan-interface>"
    exit 1
fi

# We are going to terminate VD immediately. 
echo "[35_qemu]: Urgent shutting down ..."
# save necessary info
cp qemu_screen_id_04.txt previous_qemu_screen_id_35.txt
# Stop 32_main_scheule_versatilepb.sh
echo "[35_qemu]: Stop 32_main_schedule_versatilepb.sh ..."
touch is_terminating_32.txt
rm is_running_32.txt
# first quit. 
echo "[35_qemu]: First kill ..."
screen -X quit
# Second quit. 
echo "[35_qemu]: Second kill ..."
screen_id=$(cat qemu_screen_id_04.txt)
screen -X -S $screen_id quit
# Third kill, wait for 1 second to avoid relaunch
sleep 1
echo "[35_qemu]: Third try ..."
screen_pids=`ps aux | grep SCREEN | grep -v grep | awk '{print$2}'`
for screen_pid in $screen_pids; do 
    kill -9 $screen_pid
done
screen -wipe

# Kill any sleep . 
echo "[35_qemu]: Going to kill 32 ... "
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

# Last kill, wait for 10 second to avoid relaunch
sleep 10
echo "[35_qemu]: Last kill  ..."
screen_pids=`ps aux | grep SCREEN | grep -v grep | awk '{print$2}'`
for screen_pid in $screen_pids; do 
    kill -9 $screen_pid
done
screen -wipe

# save rootfs. 
echo "[35_qemu]: backing up rootfs to attacked rootfs ..."
./25_backup_rootfs.sh bin/buildroot/ntp+telnet+rsyslog+brctl_versatilepb/rootfs.ext2

# cleaning 	
echo "[35_qemu]: cleanning up ..."
./33_clean_guest.sh $1 192.168.1.1

















