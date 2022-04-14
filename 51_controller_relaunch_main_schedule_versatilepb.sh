# This script is called to reschedule a new run
# after a port scan or DDoS attack is detected. 
#
# Basically, this script prevent the virtual device
# to be used for illegal purpose. 
#
# The key idea is to *significantly* increase the cost
# for attackers to utilize our device for monetization
# purpose. 
#
# By shutting down the vitual device, we make the 
# attackers' efforts usefulless. 
# If we wait for a sufficiently long period of time,
# e.g., 5 minutes, we can make the port scan or 
# DDoS very inefficient. 
# In addition, each time we restart, attackers must
# re-infect to exploit our VD. 
# Once they exploit our VD, we can detect and block
# it in only 1 or 2 seconds. 
#
# TODO: think about the iPhone password protection. 
# If one input a wrong password, iPhone will disable
# login for an increasingly long period of time. 
# Once the error reaches certain times, it will 
# destroy the data. 
# In our system, we will use this strategy. 
# Once we shut down the VD because of attacks, we
# will increase the time to bring back. 
# You can config this in a configuration file. 
#
# E.g., you can specify as follows. 
# 5
# 10
# 20
# 40
# 80
# 160
# 320
#
# A script is going to read line by line and uses 
# it a for loop. 
# Once it reaches the end, the script will terminate. 
# There is a cool down timer, after which the script 
# will read from the beginning. 
#

if test -z $5 ; then 
    echo "Usage: $0 <wan-interface> <cloud platform tag> <infection-relaxation> <attack-break> <pretend-attack-after-this-time>"
    echo "E.g., $0 ens4 gcp_us_east4_1_20200515_01_hd 300 400 36000"
	echo "attack-break must be greater than infection-relaxation"
    echo "pretend-attack-after-this-time: we pretend that an attack is detected after this time."
    exit 1
fi

break_duration=$4
current_id_file="current_honeypot_id.txt"
previous_id_file="previous_honeypot_id.txt"
touch is_running_51.txt
is_scanned="is_scanned_controller_01.txt"


while test -f is_running_51.txt ; do

    # clean old scanned flags 
    echo "[51_qemu]: Going to clean old scanned flags ..."
    rm $is_scanned

    # start 
	echo "[51_qemu]: Starting 32_main_schedule_versatilepb.sh ..."
    # This will start three assets: 
    # 1. qemu 
    # 2. zeek 
    # 3. tcpdump 
    # 4. log parsers 
	nohup bash ./32_main_schedule_versatilepb.sh "$1" "$2" bin/buildroot/ntp+telnet+rsyslog+brctl_versatilepb/vmlinux bin/buildroot/ntp+telnet+rsyslog+brctl_versatilepb/rootfs.ext2 bin/buildroot/ntp+telnet+rsyslog+brctl_versatilepb/raspmonitor_loadable.ko bin/buildroot/ntp+telnet+rsyslog+brctl_versatilepb/versatile-pb.dtb "$3" &

	# TODO: Now we pretend an attack happens after this time
	# This will be some detection logic in the future.
    #echo "$5" > sleep_duration_51.txt 
	#sleep $5
	#echo "[51_qemu]: Attack detected !! "

    # infinite loop to check the status of different logs
    while test ! -f $is_scanned && test -f is_running_51.txt; do 
        sleep 0.1
    done


    # Kill 32 urgently !
    # This will first kill QEMU and then send signals to kill 32, 22, and 23.
    # Finally, it save the attacked image. 
    echo "[51_qemu]: Kill Qemu urgently !! "
    ./35_kill_32_urgently.sh $1


    ## Kill tcpdump 
    echo "[51_qemu]: Going to kill tcpdump ... "
    ./95_stop_tcpdump_with_name.sh 1
    sleep 1

    ## Kill zeek 
    echo "[51_qemu]: Going to kill zeek ... "
    ./97_stop_zeek.sh 1
    sleep 1 

    ## Kill log parsers
    echo "[51_qemu]: Going to kill log parsers ... "
    python _09_kill_log_parsers.py 1 
    sleep 1

	# Check if 51 is asked to be terminated.
	if test ! -f is_running_51.txt ; then 
		break
	fi

    # break for some time. 
	echo "[51_qemu]: Going to break for $break_duration seconds ..."
	echo "[51_qemu]: To terminate, remove is_running_51.txt and wait up to $break_duration seconds"
	sleep $break_duration

done

echo "[51_qemu]: Controller Exits! "













