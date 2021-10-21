wget $(ovfenv -k cse.configUrl) -O cse-config.yaml
chmod 600 cse-config.yaml

cse install -c config.yaml -s

systemctl enable cse
systemctl start cse
