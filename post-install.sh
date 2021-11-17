chmod u+x /var/lib/cloud/scripts/per-instance/cse-init-per-instance.sh

# yum update -y >> /root/post-install.log
# yum -y install git >> /root/post-install.log
# yum -y install --downloadonly git python3-pip gcc openssl-devel bzip2-devel libffi-devel binutils linux-api-headers libxml2-python >> /root/post-install.log
# pip3 install --upgrade pip >> /root/post-install.log
# git clone -b cse_3_1_updates https://github.com/vmware/container-service-extension
# pip3 install --ignore-installed container-service-extension/ >> /root/post-install.log
# yum -y remote git >> /root/post-install.log

echo `date` >> /root/post-install.log
