yum update -y
yum -y install git python3-pip gcc openssl-devel bzip2-devel libffi-devel binutils linux-api-headers libxml2-python
pip3 install --upgrade pip
git clone $(ovfenv -k cse.repositoryUrl)
cd container-service-extension
git checkout $(ovfenv -k cse.branch)
pip3 install --ignore-installed container-service-extension/
