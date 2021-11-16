chmod u+x /var/lib/cloud/scripts/per-instance/cse-init-per-instance.sh

yum update -y >> /root/pre-install.log
yum -y install git python3-pip >> /root/pre-install.log
yum -y install --downloadonly gcc openssl-devel bzip2-devel libffi-devel binutils linux-api-headers libxml2-python >> /root/pre-install.log
pip3 install --upgrade pip >> /root/pre-install.log
git clone -b cse_3_1_updates https://github.com/vmware/container-service-extension
pip3 install --ignore-installed container-service-extension/ >> /root/pre-install.log
yum -y remote git python3-pip >> /root/pre-install.log
