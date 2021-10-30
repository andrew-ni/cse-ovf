echo preinstall >> /root/a
# ls -la /var/lib/cloud/scripts/per-boot/ >> /root/a
# echo "ovfenv $(ovfenv)" >> /root/a
vmtoolsd --cmd "info-get guestinfo.ovfenv" >> /root/pre-install-xml
perl -ne 'print $1,"\n" if (m/cse\.configUrl.*oe:value="(.*?)"/)' /root/pre-install >> /root/pre-install-url
echo preinstall >> /root/a
