
if test -z $1 ; then
    echo "Usage: $0 <path-to-rootfs-image>"
    exit 1
fi


previous_honeypot_id=$(cat previous_honeypot_id.txt)
current_id_file="current_honeypot_id.txt"
previous_id_file="previous_honeypot_id.txt"


if test -f $current_id_file ; then
    mv $current_id_file $previous_id_file
else
    echo "" > $previous_id_file
fi

file_name=`echo "$1" | rev | cut -d '/' -f 1 | rev `
path=`echo "$1" | rev | cut -d '/' -f 2- | rev`

# -f option forces gunzip to overwrite
cd $path
# save old rootfs image 
mkdir saved_rootfs
echo "[24_qemu]: saving old rootfs ... "
cp "$file_name" "$file_name.$previous_honeypot_id.snapshot"
tar -zcf "$file_name.$previous_honeypot_id.tar.gz" "$file_name.$previous_honeypot_id.snapshot"
mv "$file_name.$previous_honeypot_id.tar.gz" saved_rootfs
rm "$file_name.$previous_honeypot_id.snapshot"
# release fresh new rootfs
echo "[24_qemu]: releasing new rootfs ... "
cp "$file_name.gz.back" "$file_name.gz" 
gunzip -f "$file_name.gz"

cd -
