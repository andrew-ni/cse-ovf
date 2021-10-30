#!/bin/bash
echo cseinitperinstance >> /root/a
vmtoolsd --cmd "info-get guestinfo.ovfenv" > /root/cse-init-per-instance-xml
perl -ne 'print $1,"\n" if (m/cse\.configUrl.*oe:value="(.*?)"/)' /root/cse-init-per-instance-xml > /root/cse-init-per-instance-url
wget $(cat /root/cse-init-per-instance-url) -O /root/cse-config.yaml
chmod 600 /root/cse-config.yaml
cse install -c /root/cse-config.yaml -s -t > /root/cse-install-output.log
systemctl enable cse
systemctl start cse
echo cseinitperinstance >> /root/a
