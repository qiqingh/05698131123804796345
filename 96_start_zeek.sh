# Note, it is important to make sub folders for each run. 
# Every time attack happends, we will relaunch zeek. 
#
# 

if test -z $1 ; then 
    echo "Usage: $0 <path_to_execute>"
    exit 1
fi

current_path=$(pwd)
mkdir -p $1
chmod 775 $1
echo $1 > zeek_path_96.txt
cd $1
nohup /opt/zeek/bin/zeek -i tap0 -C $current_path/detectSSHTELNET.zeek $current_path/portScan.zeek &
cd -