
if test -z $1 ; then 
	echo "Usage: $0 <module-path>"
	echo "E.g., $0 bin//32-detector-noprinted/raspmonitor_loadable.ko"
	exit 1
fi


# copy raspmonitor.ko to the guest
sshpass -p admin scp -oStrictHostKeyChecking=no "$1" root@192.168.1.1:~

# Set the console printk level to 5, so that printk will not display on the console.
# install raspmonitor.ko in the guest and remove it
sshpass -p admin ssh -oStrictHostKeyChecking=no root@192.168.1.1 'echo 6 > /proc/sys/kernel/printk; insmod ~/raspmonitor_loadable.ko; rm ~/raspmonitor_loadable.ko'
