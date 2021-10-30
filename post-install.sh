echo postinstall >> /root/a
# ls -la /var/lib/cloud/scripts/per-boot/ >> /root/a

echo "ovfenv $(ovfenv)" >> /root/a
# wget $(ovfenv) -O /root/cse-config.yaml
chmod u+x /var/lib/cloud/scripts/per-boot/cse-init-per-boot.sh
chmod u+x /var/lib/cloud/scripts/per-instance/cse-init-per-instance.sh
# sed -i 's/scripts-user/[scripts-user, always]/g' /etc/cloud/cloud.cfg
echo postinstall >> /root/a
