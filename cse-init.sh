echo $(ovfenv -k cse.configUrl) > /root/sanity-cse-init.yaml
wget $(ovfenv -k cse.configUrl) -O /root/cse-config.yaml
chmod 600 /root/cse-config.yaml

cse install -c /root/cse-config.yaml -s -t

systemctl enable cse
systemctl start cse
