#!/bin/bash
touch /root/cse-init-per-boot
echo $(ovfenv -k cse.configUrl) >> /root/cse-init-per-boot
# echo hello >> /root/cse-init-per-boot
# wget $(ovfenv -k cse.configUrl) -O /root/cse-config.yaml
# chmod 600 /root/cse-config.yaml
# cse install -c /root/cse-config.yaml -s -t
# systemctl enable cse
# systemctl start cse
