#!/bin/bash

echo `date` >> /root/cse-init-per-instance.log
# order matters here: gcc needs mpc installed first
rpm -Uvvh /var/cache/tdnf/photon-updates/rpms/x86_64/*.rpm >> /root/cse-init-per-instance.log
rpm -Uvvh /var/cache/tdnf/photon/rpms/x86_64/*.rpm >> /root/cse-init-per-instance.log
rpm -Uvvh /var/cache/tdnf/photon-updates/rpms/noarch/*.rpm >> /root/cse-init-per-instance.log

pip3 install --ignore-installed container_service_extension-3.1.2.dev10-py3-none-any.whl >> /root/cse-init-per-instance.log

vmtoolsd --cmd "info-get guestinfo.ovfenv" > /root/ovfenv
perl -ne 'print $1,"\n" if (m/cse\.configUrl.*oe:value="(.*?)"/)' /root/ovfenv > /root/configUrl
wget $(cat /root/configUrl) -O /root/cse-config.yaml
chmod 600 /root/cse-config.yaml
cse install -c /root/cse-config.yaml -s -t > /root/cse-install-output.log
cse upgrade -c /root/cse-config.yaml -s -t > /root/cse-upgrade-output.log
systemctl enable cse
systemctl start cse
echo `date` >> /root/cse-init-per-instance.log
