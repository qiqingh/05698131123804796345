

## You can call this script at any time
# It's not harmful.


# Do not check target's host keys.
# Ping 8.8.8.8 and print the error code. 
sshpass -p admin ssh -oStrictHostKeyChecking=no root@192.168.1.1 'ping 8.8.8.8 -c 1 -W 2 > /dev/null 2>&1; echo $?' > guest_init_status_11.txt
output=$(cat guest_init_status_11.txt)
if test $output -eq "0" ; then
	echo "[11_qemu]: Guest can ping 8.8.8.8"
else
	echo "[11_qemu]: Guest cannot ping 8.8.8.8"
fi
