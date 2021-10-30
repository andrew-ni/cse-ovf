# yum update -y
# yum -y install git python3-pip gcc openssl-devel bzip2-devel libffi-devel binutils linux-api-headers libxml2-python
# pip3 install --upgrade pip
# git clone -b cse_3_1_updates https://github.com/vmware/container-service-extension
# pip3 install --ignore-installed container-service-extension/
# chmod u+x /var/lib/cloud/scripts/per-boot/cse-init-per-boot.sh
# chmod u+x /var/lib/cloud/scripts/per-instance/cse-init-per-instance.sh
# sed -i 's/scripts-user/[scripts-user, always]/g' /etc/cloud/cloud.cfg

echo capfirstboot >> /root/a
# ls -la /var/lib/cloud/scripts/per-boot/ >> /root/a
# echo "ovfenv $(ovfenv)" >> /root/a
# vmtoolsd --cmd "info-get guestinfo.ovfenv" >> /root/a
echo capfirstboot >> /root/a
