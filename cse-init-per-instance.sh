#!/bin/bash

config_filepath=/root/cse-config.yaml
log_filepath=/root/cse-init-per-instance.log


echo `date` >> $log_filepath
# order matters here: gcc needs mpc installed first
rpm -Uvvh /var/cache/tdnf/photon-updates/rpms/x86_64/*.rpm >> $log_filepath
rpm -Uvvh /var/cache/tdnf/photon/rpms/x86_64/*.rpm >> $log_filepath
rpm -Uvvh /var/cache/tdnf/photon-updates/rpms/noarch/*.rpm >> $log_filepath

pip3 install --upgrade /root/pip-21.3.1-py3-none-any.whl >> $log_filepath
pip3 install --ignore-installed /root/container_service_extension-3.1.2.dev46-py3-none-any.whl >> $log_filepath

vmtoolsd --cmd "info-get guestinfo.ovfenv" > /root/ovfenv
perl -ne 'print $1,"\n" if (m/cse\.mqttVerifySsl.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.vcdHost.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.vcdUsername.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.vcdPassword.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.vcdVerifySsl.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.serviceTelemetry.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.brokerOrg.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.brokerOvdc.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.brokerCatalog.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.brokerNetwork.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.brokerStorageProfile.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties
perl -ne 'print $1,"\n" if (m/cse\.brokerRemoteTemplateCookbookUrl.*oe:value="(.*?)"/)' /root/ovfenv >> /root/properties

cse sample -o $config_filepath \
    -x mqtt_verify $(perl -ne 'print $1,"\n" if (m/cse\.mqttVerifySsl.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x vcd_host $(perl -ne 'print $1,"\n" if (m/cse\.vcdHost.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x username $(perl -ne 'print $1,"\n" if (m/cse\.vcdUsername.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x password $(perl -ne 'print $1,"\n" if (m/cse\.vcdPassword.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x vcd_verify $(perl -ne 'print $1,"\n" if (m/cse\.vcdVerifySsl.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x enable_telemetry $(perl -ne 'print $1,"\n" if (m/cse\.serviceTelemetry.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x org_name $(perl -ne 'print $1,"\n" if (m/cse\.brokerOrg.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x broker.vdc $(perl -ne 'print $1,"\n" if (m/cse\.brokerOvdc.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x catalog_name $(perl -ne 'print $1,"\n" if (m/cse\.brokerCatalog.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x broker.network $(perl -ne 'print $1,"\n" if (m/cse\.brokerNetwork.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x broker.storage_profile $(perl -ne 'print $1,"\n" if (m/cse\.brokerStorageProfile.*oe:value="(.*?)"/)' /root/ovfenv) \
    -x broker.remote_template_cookbook_url $(perl -ne 'print $1,"\n" if (m/cse\.brokerRemoteTemplateCookbookUrl.*oe:value="(.*?)"/)' /root/ovfenv)

# perl -ne 'print $1,"\n" if (m/cse\.configUrl.*oe:value="(.*?)"/)' /root/ovfenv > /root/configUrl
# wget $(cat /root/configUrl) -O $config_filepath

sed 's/\  enforce_authorization: false/\  enforce_authorization: true/g' $config_filepath > $config_filepath
chmod 600 $config_filepath

perl -ne 'print $1,"\n" if (m/cse\.vcentersNames.*oe:value="(.*?)"/)' /root/ovfenv >> /root/vcNames
perl -ne 'print $1,"\n" if (m/cse\.vcentersUsernames.*oe:value="(.*?)"/)' /root/ovfenv >> /root/vcUsernames
perl -ne 'print $1,"\n" if (m/cse\.vcentersPasswords.*oe:value="(.*?)"/)' /root/ovfenv >> /root/vcPasswords
perl -ne 'print $1,"\n" if (m/cse\.vcentersVerify.*oe:value="(.*?)"/)' /root/ovfenv >> /root/vcVerify

python3 /root/set-vcenters.py $config_filepath /root/vcNames /root/vcUsernames /root/vcPasswords /root/vcVerify

cse install -c $config_filepath -s > /root/cse-install-output.log
cse upgrade -c $config_filepath -s > /root/cse-upgrade-output.log
systemctl enable cse
systemctl start cse
echo `date` >> $log_filepath
