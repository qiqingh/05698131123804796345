#########################################
# Warning! This script will not return
# Please use a screen to execute it.
#
#########################################

echo $STY > qemu_screen_id_04.txt

### Use in-memory storage

#if test -z $2 ; then 
#	echo "Usage: $0 <kernel-image> <tap-name>"
#	echo "E.g., $0 openwrt-armvirt-32-zImage-initramfs tap0"
#	exit 1
#fi

#qemu-system-arm -nographic -M virt -m 64 -kernel "$1" -net nic -net tap,ifname="$2",script=no

#exit 1

### Use out-memory storage

# if test -z $4 ; then 
# 	echo "Usage: $0 <kernel-image> <file-system-image> <tap-name> <.dtb-file>"
# 	echo "E.g., $0 openwrt-armvirt-32-zImage openwrt-armvirt-32-rootfs-ext4.img tap0 versatile-pb.dtb"
# 	exit 1
# fi
# sudo qemu-system-arm -nographic -M virt -m 256 -drive if=none,file="$2",format=raw,id=hd0  -device virtio-blk-device,drive=hd0 -kernel "$1" -append "root=/dev/vda" -net nic -net tap,ifname="$3",script=no


# sudo qemu-system-arm -M versatilepb \
# -kernel "$1" -dtb "$4" \
# -drive file="$2",if=scsi,format=raw \
# -append "root=/dev/sda console=ttyAMA0,115200" \
# -nographic -net nic,model=rtl8139 \
# -net tap,ifname="$3"

sudo qemu-system-mips -nographic \
-M malta \
-kernel "$1" \
-hda "$2"  \
-append "root=/dev/hda console=tty0" \
-net nic -net tap,ifname="$3",script=no


# sudo qemu-system-ppc -nographic \
# -M mac99 \
# -m 256 \
# -kernel "$1" \
# -hda "$2" \
# -append "root=/dev/sda" \
# -net nic -net tap,ifname="$3",script=no

# sudo qemu-system-sparc -nographic -M SS-10 \
# -m 256 \
# -kernel zImage \
# -hda rootfs.ext2 \
# -append "root=/dev/sda" \
# -net nic -net tap,ifname=tap0,script=no

# sudo qemu-system-sparc -nographic -M SS-10 \
# -m 256 \
# -kernel zImage \
# -hda rootfs.qcow2 \
# -append "root=/dev/sda" \
# -net nic -net tap,ifname=tap0,script=no

