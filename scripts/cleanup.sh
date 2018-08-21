#!/usr/bin/env bash

# Remove some of the files/setups we do not need anymore
echo "Start cleanup"

# Shred any sensitive data
echo '** Shredding sensitive data ...'
shred -u /etc/ssh/*_key /etc/ssh/*_key.pub,
shred -u /root/.*history /home/ec2-user/.*history
shred -u /root/.ssh/authorized_keys /home/ec2-user/.ssh/authorized_keys
sync
sleep 1
sync

echo "Finished cleanup"
