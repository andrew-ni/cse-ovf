#!/bin/bash
# touch /root/cse-init-per-boot
# echo $(ovfenv -k cse.configUrl) >> /root/cse-init-per-boot
# echo hello >> /root/cse-init-per-boot
# wget $(ovfenv -k cse.configUrl) -O /root/cse-config.yaml
# chmod 600 /root/cse-config.yaml
# cse install -c /root/cse-config.yaml -s -t
# systemctl enable cse
# systemctl start cse

echo cseinitperboot >> /root/a
# ls -la /var/lib/cloud/scripts/per-boot/ >> /root/a
# echo "ovfenv $(ovfenv)" >> /root/a
vmtoolsd --cmd "info-get guestinfo.ovfenv" > /root/cse-init-per-boot-xml
perl -ne 'print $1,"\n" if (m/cse\.configUrl.*oe:value="(.*?)"/)' /root/cse-init-per-boot-xml > /root/cse-init-per-boot-url
echo cseinitperboot >> /root/a
