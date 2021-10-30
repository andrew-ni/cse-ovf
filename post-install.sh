echo postinstall >> /root/a
ls -la /var/lib/cloud/scripts/per-boot/ >> /root/a

echo $(ovfenv -k cse.configUrl) >> /root/a
wget $(ovfenv -k cse.configUrl) -O /root/cse-config.yaml
chmod u+x /var/lib/cloud/scripts/per-boot/cse-init-per-boot.sh
chmod u+x /var/lib/cloud/scripts/per-instance/cse-init-per-instance.sh

echo postinstall >> /root/a
