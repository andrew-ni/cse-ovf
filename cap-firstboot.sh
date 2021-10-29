yum update -y
yum -y install git python3-pip gcc openssl-devel bzip2-devel libffi-devel binutils linux-api-headers libxml2-python
pip3 install --upgrade pip
git clone https://github.com/vmware/container-service-extension
pip3 install --ignore-installed container-service-extension/
chmod u+x /var/lib/cloud/scripts/per-boot/cse-init-per-boot.sh
chmod u+x /var/lib/cloud/scripts/per-instance/cse-init-per-instance.sh
