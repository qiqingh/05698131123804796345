#!/bin/bash


if [[ -z $8 ]]; then 
    echo "Usage: $0 <path-to-dropbear.log> <sleep seconds> <wan-interface> <cloud_platform> <image> <rootfs> <module-path> <dtb-path>"
    exit 1
fi

new_count=$(grep "Password auth succeeded" "$1" | wc -l)

old_count=$(cat ssh_success_count_22.txt)

is_terminating_32="is_terminating_32.txt"
is_running_32="is_running_32.txt"
honeypot_id_file="current_honeypot_id.txt"


# New login occur, need to restart
if test $new_count -gt $old_count; then 
    #echo $new_count > ssh_success_count_22.txt 
    echo "[22_qemu]: New ssh login occurs, going to reboot ... "
    echo "[22_qemu]: Sleeping for $2 seconds"
    echo "$2" > sleep_duration_22.txt
    sleep $2
    #echo "[22_qemu]: Backing up logs ... "
    #log_path=`echo $1 | rev | cut -d "/" -f 3- | rev`
    #cp -r "$log_path" "$log_path.ssh"
    echo "[22_qemu]: Going to relaunch ... "
	# Clean up any old qemu (kill screen sessions and qemu)
	./33_clean_guest.sh "$3" 192.168.1.1
	sleep 1
    # Back up images 
    echo "[22_qemu]: Cleaning old rootfs image ... "
    ./24_retrive_new_rootfs.sh "$6"
    sleep 1

    # Kill zeek 
    echo "[22_qemu]: Terminating zeek  ... "
    ./97_stop_zeek.sh 1
    # kill tcpdump
    echo "[22_qemu]: Terminating tcpdump ... "
    ./95_stop_tcpdump_with_name.sh 1
    # kill log parsers
    echo "[22_qemu]: Terminating log parsers ... "
    python _09_kill_log_parsers.py 1
    sleep 1

    if test -f $is_terminating_32 || test ! -f $is_running_32 ; then
        echo "0" > ssh_success_count_22.txt
        echo "0" > telnet_success_count_23.txt 
        exit 1
    fi

	# relaunch the qemu
    echo "[22_qemu]: Relaunching new instance..."
	./31_relaunch_guest_versatilepb.sh "$3" "$4" "$5" "$6" "$7" "$8"
	sleep 1

	# setup host rsyslog server
	echo "[22_qemu]: Setting up host rsyslog server ..."
	./06_setup_host_rsyslog.sh

    # launch zeek 
    if test -f $honeypot_id_file && test ! -f $is_terminating_32 ; then 
        echo "[22_qemu]: Relaunching zeek ..."
        honeypot_id=`cat $honeypot_id_file`
        ./96_start_zeek.sh ../zeek/$honeypot_id
    else
        echo "[22_qemu]: Zeek is not going to relaunch ... "
    fi

    # call tcpdump 
    if test -f $honeypot_id_file && test ! -f $is_terminating_32 ; then
        echo "[22_qemu]: Relaunching tcpdump ..."
        honeypot_id=`cat $honeypot_id_file` 
        ./94_start_tcpdump_with_name.sh ../pcap/$honeypot_id tap0
    else
        echo "[22_qemu]: Tcpdump is not going to relaunch ... "
    fi

    # launch log parsers 
    if test -f $honeypot_id_file && test ! -f $is_terminating_32 ; then
        echo "[22_qemu]: Relaunching log parsers ..."
        honeypot_id=`cat $honeypot_id_file`
        nohup python _00_run_log_parsers.py logs/$honeypot_id/127/kernel.log ../zeek/$honeypot_id/notice.log &
    else 
        echo "[22_qemu]: Log parsers are not going to relaunch ... "
    fi


    # Initialize login information
    echo "[22_qemu]: Initializing login information ..."
    #grep "Password auth succeeded" "$1" | wc -l > ssh_success_count_22.txt
    #grep "root login on" "$1" | wc -l > telnet_success_count_23.txt
    echo "0" > ssh_success_count_22.txt
    echo "0" > telnet_success_count_23.txt
fi
