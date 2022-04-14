# This script is used to launch a qemu guest
# It may take upto 300 seconds to finish
# To check the status, read the guest_init_status_11.txt
# 1 means unsuccessful; 1 means successful

if test -z $6 ; then 
	echo "Usage: $0 <wan-lan-interface> <cloud_platform> <image> <rootfs> <module-path> <dtb-file>"
	echo "E.g., $0 eno1 cloudlab bin/buildroot/telnet+rsyslog+brctl_versatilepb/zImage bin/buildroot/telnet+rsyslog+brctl_versatilepb/rootfs.ext2 bin/buildroot/telnet+rsyslog+brctl_versatilepb/raspmonitor_loadable.ko bin/buildroot/telnet+rsyslog+brctl_versatilepb/versatile-pb.dtb"
	exit 1
fi

# Back up old id file
honeypot_id_file="current_honeypot_id.txt"
previous_id_file="previous_honeypot_id.txt"
echo "[31_qemu]: Backing up old $honeypot_id_file ... "
rm $honeypot_id_file

# Remove NAT rules
echo "[31_qemu]: Removing NAT rules ... "
./14_recover_public_ip.sh "$1" 192.168.1.1


# Launch the qemu in a screen and detach from the screen
echo "[31_qemu]: Launching qemu instance ... "
screen -d -m ./04_start_qemu_versatilepb.sh "$3" "$4" tap0 "$6"


# Clear all the states.
echo "[31_qemu]: Initializing status files ... "
echo "1" > guest_net_ready_31.txt
echo "1" > guest_init_status_11.txt
echo "1" > guest_kernel_module_status_34.txt

# Clear old ssh known_hosts
echo "[31_qemu]: Removing old SSH known_hosts ... "
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.1.1"

## Wait up to 120 seconds for the guest network to get ready
echo "[31_qemu]: Waiting the qemu instance to be ready ..."
count=1
while test $count -le 30 ; do
	sshpass -p admin ssh -oStrictHostKeyChecking=no -o ConnectTimeout=2 root@192.168.1.1 'exit 0'
	echo $? > guest_net_ready_31.txt
	ret=$(cat guest_net_ready_31.txt)
	# If the guest network is ready
	if test "$ret" -eq 0 ; then
		# echo "[31_qemu]: Configuring the guest ..."
		# login guest, change password, add route
		# ./10_configure_guest_versatilepb.sh 192.168.1.1 admin
        # sleep 1
		# login guest, test whether it can ping 8.8.8.8
		# The result is in guest_init_status_11.txt
		echo "[31_qemu]: Testing the guest ..."
		./11_test_guest_init_status.sh
		break
	fi
	echo "[31_qemu]: Waiting the qemu instance to be ready ..."
	sleep 1
	count=$(($count+1))
done


ret=$(cat guest_init_status_11.txt)
if test $ret -eq 0 ; then
	# install kernel modeul
	echo "[31_qemu]: Installing kernel moduel in guest ..."
	./12_install_raspmonitor.sh "$5"
	sleep 1
	# Add NAT rule to make guest visible by outside.
	echo "[31_qemu]: Adding NAT rules ..."
	./13_replace_public_ip.sh "$1" 192.168.1.1
	# Generate current_honeypot_id.txt
	uniq_id=$(date +%s)
	echo "[31_qemu]: Writing honypot id ($2_$uniq_id) to current_honypot_id.txt"
	echo "$2_$uniq_id" > $honeypot_id_file
	echo "[31_qemu]: Relaunch complete!"
	exit 0
fi

echo "[31_qemu]: Relaunch fails, may be 600 seconds is not enough! Try to ping 192.168.1.1 manually."
echo "[31_qemu]: To kill the semi-luanched instance, use 'screen -X -S [screen id] quit'"
exit 1


