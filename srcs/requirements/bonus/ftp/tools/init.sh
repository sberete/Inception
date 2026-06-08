#!/bin/bash

set -e

id ftpuser &>/dev/null || useradd -m ftpuser

echo "ftpuser:1234" | chpasswd

mkdir -p /home/ftpuser/wordpress

cat > /etc/vsftpd.conf << EOF
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022

chroot_local_user=YES
allow_writeable_chroot=YES

pasv_enable=NO
EOF

exec vsftpd /etc/vsftpd.conf
