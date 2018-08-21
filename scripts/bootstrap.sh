#!/bin/bash -eux
#!/bin.bash

mkfs -t ext4 /dev/xvdf
mkdir -p /u01
mount /dev/xvdf /u01
echo "/dev/xvdf               /u01             ext4    noatime         0 0" >> /etc/fstab
