

# -f option forces gunzip to overwrite
cd bin/lede-17.01/dropbear+telnet+adduser+cd/
cp lede-armvirt-root.ext4.gz.back lede-armvirt-root.ext4.gz
gunzip -f lede-armvirt-root.ext4.gz
cd -

cd bin/buildroot/ntp+telnet+rsyslog+brctl_versatilepb/
cp rootfs.ext2.gz.back rootfs.ext2.gz
gunzip -f rootfs.ext2.gz
cd -
