yum update -y
yum -y install git python3-pip gcc openssl-devel bzip2-devel libffi-devel binutils linux-api-headers
pip3 install --upgrade pip
git clone https://github.com/vmware/container-service-extension.git
pip3 install container-service-extension/
