# This script is the main loop 
# You can just run this sript in terminal, then it will do everything
# You can also specify the email of the admin to notify him/her when fail.
#
# >> How to start? You should use the following syntax
#
#  option1:  bash ./32_main_schedule.sh eno1 cloudlab
#  option2:  sh ./32_main_schedule.sh eno1 cloudlab
#
# >> How to stop? You just remove the current_honeypot_id.txt
#
#


if test -z $7 ; then 
	echo "Usage: $0 <wan-lan-interface> <cloud_platform> <image> <rootfs> <module-path> <dtb-file> <infection-sleep>"
	echo "E.g., $0 eno1 cloudlab bin/buildroot/telnet+rsyslog+brctl_versatilepb/zImage bin/buildroot/telnet+rsyslog+brctl_versatilepb/rootfs.ext2 bin/buildroot/telnet+rsyslog+brctl_versatilepb/raspmonitor_loadable.ko bin/buildroot/telnet+rsyslog+brctl_versatilepb/versatile-pb.dtb 300"
    exit 1
fi

is_running="is_running_32.txt"
is_terminating_32="is_terminating_32.txt"
honeypot_id_file="current_honeypot_id.txt"
previous_id_file="previous_honeypot_id.txt"
rm $is_running
rm $is_terminating_32

# Main loop
counter=0
while test true ; do

	# Check the heart beat every loop
	./21_heart_beat_from_guest.sh
	heart=$(cat heart_beat_21.txt)
	if test $heart -eq 0 ; then 
		echo "[32_qemu]: Alive"
	else
		echo "[32_qemu]: Dead, going to recover ..."
		echo "[32_qemu]: Cleaning old instance ..."
		# Clean up any old qemu (kill screen sessions and qemu)
		./33_clean_guest.sh "$1" 192.168.1.1
		sleep 1
        echo "[32_qemu]: Cleaning old rootfs image ... "
        ./24_retrive_new_rootfs.sh "$4"
        sleep 1
        if test -f $is_terminating_32 ; then
            break
        fi
		echo "[32_qemu]: Relaunching new instance..."
		# relaunch the qemu
		./31_relaunch_guest_versatilepb.sh "$1" "$2" "$3" "$4" "$5" "$6"
		if test -f $honeypot_id_file && test ! -f $is_terminating_32 ; then
            touch $is_running
        fi
		sleep 1
		# setup host rsyslog server
		echo "[32_qemu]: Setting up host rsyslog server ..."
		./06_setup_host_rsyslog.sh 

        # launch zeek 
        if test -f $honeypot_id_file && test ! -f $is_terminating_32 ; then 
            echo "[32_qemu]: Launching zeek ..."
            honeypot_id=`cat $honeypot_id_file`
            ./96_start_zeek.sh ../zeek/$honeypot_id
        else
            echo "[32_qemu]: Zeek is not going to launch ... "
        fi

        # call tcpdump 
        if test -f $honeypot_id_file && test ! -f $is_terminating_32 ; then
            echo "[32_qemu]: Launching tcpdump ..."
            honeypot_id=`cat $honeypot_id_file` 
            ./94_start_tcpdump_with_name.sh ../pcap/$honeypot_id tap0
        else
            echo "[32_qemu]: Tcpdump is not going to launch ... "
        fi

        # launch log parsers 
        if test -f $honeypot_id_file && test ! -f $is_terminating_32 ; then
            echo "[32_qemu]: Relaunching log parsers ..."
            honeypot_id=`cat $honeypot_id_file`
            nohup python _00_run_log_parsers.py logs/$honeypot_id/127/kernel.log ../zeek/$honeypot_id/notice.log &
        else 
            echo "[32_qemu]: Log parsers are not going to relaunch ... "
        fi

        #echo "[32_qemu]: Waiting 3 seconds for logs to be generated ... "
        #sleep 3
        # Initialize login information
        #current_honeypot_id=$(cat current_honeypot_id.txt)
        #ssh_log_path="logs/$current_honeypot_id/127/dropbear.log"
        #telnet_log_path="logs/$current_honeypot_id/127/login.log"
        echo "[32_qemu]: Initializing login information ..."
        #grep "Password auth succeeded" "$ssh_log_path" | wc -l > ssh_success_count_22.txt
        #grep "root login on" "$telnet_log_path" | wc -l > telnet_success_count_23.txt
        echo "0" > ssh_success_count_22.txt
        echo "0" > telnet_success_count_23.txt
	fi

	# This will cost 1 * 60 = 60 seconds
	timer=0
	while test $timer -lt 360 ; do 
		if test -f $is_running && test ! -f $is_terminating_32 ; then 
            
			# This will allow infected VD to be online for a while so that attackers can use it
            # for monetization 
			current_honeypot_id=`cat $honeypot_id_file`
            ssh_log_path="logs/$current_honeypot_id/127/dropbear.log"
            infection_relaxation=$7
            ./22_check_ssh_success_count_versatilepb.sh $ssh_log_path $infection_relaxation "$1" "$2" "$3" "$4" "$5" "$6"
			if test -f $honeypot_id_file && test ! -f $is_terminating_32 ; then
                touch $is_running
            fi
			current_honeypot_id=`cat $honeypot_id_file`
            telnet_log_path="logs/$current_honeypot_id/127/login.log"
            ./23_check_telnet_success_count_versatilepb.sh $telnet_log_path $infection_relaxation "$1" "$2" "$3" "$4" "$5" "$6"
			if test -f $honeypot_id_file && test ! -f $is_terminating_32 ; then
                touch $is_running
            fi
			total_count=`expr $counter \* 360`
			total_count=$(($total_count+$timer))
			echo "[32_qemu]: Waiting 1 second  ... (total iteration: $total_count)"
			sleep 1
			timer=$(($timer+1))
		else
			echo "[32_qemu]: $0 is going to exit ... "
            echo "[32_qemu]: Going to recover public IP ..."
			./14_recover_public_ip.sh $1 192.168.1.1
			echo "[32_qemu]: please call ./33_clean_guest.sh manually to terminate QEMU"
			exit 1
		fi
	done 
	counter=$(($counter+1))

done   # end of main loop



echo "[32_qemu]: $0 is being killed ... "
echo "[32_qemu]: Going to recover public IP ..."
./14_recover_public_ip.sh $1 192.168.1.1
echo "[32_qemu]: please call ./33_clean_guest.sh manually to terminate QEMU"
exit 1


