
if test -z $1 ; then
    echo "Usage: $0 <path-to-rootfs-image>"
    exit 1
fi


previous_honeypot_id=$(cat previous_honeypot_id.txt)
file_name=`echo "$1" | rev | cut -d '/' -f 1 | rev `
path=`echo "$1" | rev | cut -d '/' -f 2- | rev`

cd $path
# save old rootfs image 
mkdir attacked_rootfs 
cp "$file_name" "$file_name.$previous_honeypot_id.attack.snapshot"
echo "[25_qemu]: packing rootfs ... "
tar -zcf "$file_name.$previous_honeypot_id.attack.tar.gz" "$file_name.$previous_honeypot_id.attack.snapshot"
mv "$file_name.$previous_honeypot_id.attack.tar.gz" attacked_rootfs
rm "$file_name.$previous_honeypot_id.attack.snapshot"
cd -
