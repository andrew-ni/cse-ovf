yum update -y
yum -y install git python3-pip gcc openssl-devel bzip2-devel libffi-devel binutils linux-api-headers libxml2-python
pip3 install --upgrade pip
git clone https://github.com/vmware/container-service-extension
pip3 install --ignore-installed container-service-extension/

git clone https://github.com/andrew-ni/cse-ovf.git
mv cse-ovf/cse.service /etc/systemd/system/cse.service
mv cse-ovf/cse-run.sh /root/cse-run.sh
mv cse-ovf/cse-init-per-boot.yaml /var/lib/cloud/scripts/per-boot/cse-init-per-boot.yaml
mv cse-ovf/cse-init-per-instance.yaml /var/lib/cloud/scripts/per-instance/cse-init-per-instance.yaml


# echo $(ovfenv -k cse.configUrl) > /root/sanity-cap-firstboot.yaml
# wget $(ovfenv -k cse.configUrl) -O /root/cse-config.yaml
# chmod 600 /root/cse-config.yaml

# cse install -c /root/cse-config.yaml -s -t

# systemctl enable cse
# systemctl start cse
