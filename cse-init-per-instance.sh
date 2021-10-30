#!/bin/bash
echo cseinitperinstance >> /root/a
yum update -y
yum -y install git python3-pip gcc openssl-devel bzip2-devel libffi-devel binutils linux-api-headers libxml2-python
pip3 install --upgrade pip
git clone -b cse_3_1_updates https://github.com/vmware/container-service-extension
pip3 install --ignore-installed container-service-extension/

vmtoolsd --cmd "info-get guestinfo.ovfenv" > /root/cse-init-per-instance-xml
perl -ne 'print $1,"\n" if (m/cse\.configUrl.*oe:value="(.*?)"/)' /root/cse-init-per-instance-xml > /root/cse-init-per-instance-url
wget $(cat /root/cse-init-per-instance-url) -O /root/cse-config.yaml
chmod 600 /root/cse-config.yaml
cse install -c /root/cse-config.yaml -s -t > /root/cse-install-output.log
systemctl enable cse
systemctl start cse
echo cseinitperinstance >> /root/a
