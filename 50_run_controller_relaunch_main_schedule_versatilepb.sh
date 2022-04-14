

if test -z $5 ; then 
    echo "Usage: $0 <wan-interface> <cloud platform tag> <infection relaxation> <break duration> <pretend-attack-after-this-time>"
    echo "E.g., $0 ens4 gcp_us_east4_1_20200515_01_hd 300 400 36000"
	echo "attack-break must be greater than infection-relaxation"
    echo "pretend-attack-after-this-time: we pretend that an attack is detected after this time."
    exit 1
fi

if test ! $3 -lt $4 ; then 
	#echo "[50_qemu]: ERROR: infection relaxation must be less than break duration. "
	echo "[50_qemu]: It's recommned that infection relaxation at least less than break duration - 120"
	# exit 1
fi

nohup bash ./51_controller_relaunch_main_schedule_versatilepb.sh "$1" "$2" "$3" "$4" "$5" > nohup_51.out &
