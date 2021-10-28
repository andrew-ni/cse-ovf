yum update -y
yum -y install git python3-pip gcc openssl-devel bzip2-devel libffi-devel binutils linux-api-headers libxml2-python
pip3 install --upgrade pip
git clone https://github.com/vmware/container-service-extension
pip3 install --ignore-installed container-service-extension/

git clone https://github.com/andrew-ni/cse-ovf.git
mv cse-ovf/cse.service cse-ovf/systemd/system/cse.service
mv cse-ovf/cse-run.sh /root/cse-run.sh

wget $(ovfenv -k cse.configUrl) -O cse-config.yaml
chmod 600 cse-config.yaml

cse install -c cse-config.yaml -s -t

systemctl enable cse
systemctl start cse
