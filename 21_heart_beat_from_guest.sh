
# If this script ends with a return value (echo $?) of nonzero, 
# It indicates the heat beat is failed.
# In addition, you can check the heart_beat.txt to read the value.
## You can call this script at any time
# It's not harmful.


# Check the network connection
ping 192.168.1.1 -c 1 -W 1
echo $? > heart_beat_21.txt
ret=$(cat heart_beat_21.txt)
if test "$ret" -ne 0 ; then 
	exit 1
fi


# Check the SSH connection and update route.
#sshpass -p admin ssh -oStrictHostKeyChecking=no -o ConnectTimeout=2 root@192.168.1.1 'ip route add 0.0.0.0/0 via 192.168.1.2 dev br-lan; exit 0'
#echo $? > heart_beat_21.txt
#ret=$(cat heart_beat_21.txt)
#if test "$ret" -ne 0 ; then 
#	exit 1
#fi

exit 0

