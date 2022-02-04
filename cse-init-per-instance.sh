#!/bin/bash

config_filepath=/root/cse-config.yaml
log_filepath=/root/cse-init-per-instance.log
properties_filepath=/root/properties
ovfenv_filepath=/root/ovfenv

echo `date` >> $log_filepath
# order matters here: gcc needs mpc installed first
rpm -Uvvh /var/cache/tdnf/photon-updates/rpms/x86_64/*.rpm >> $log_filepath
rpm -Uvvh /var/cache/tdnf/photon/rpms/x86_64/*.rpm >> $log_filepath
rpm -Uvvh /var/cache/tdnf/photon-updates/rpms/noarch/*.rpm >> $log_filepath

pip3 install --upgrade /root/pip-21.3.1-py3-none-any.whl >> $log_filepath
pip3 install --ignore-installed /root/container_service_extension-3.1.2.dev46-py3-none-any.whl >> $log_filepath

vmtoolsd --cmd "info-get guestinfo.ovfenv" > $ovfenv_filepath

mqttVerifySsl=$(perl -ne 'print $1,"\n" if (m/cse\.mqttVerifySsl.*oe:value="(.*?)"/)' $ovfenv_filepath)
vcdHost=$(perl -ne 'print $1,"\n" if (m/cse\.vcdHost.*oe:value="(.*?)"/)' $ovfenv_filepath)
vcdUsername=$(perl -ne 'print $1,"\n" if (m/cse\.vcdUsername.*oe:value="(.*?)"/)' $ovfenv_filepath)
vcdPassword=$(perl -ne 'print $1,"\n" if (m/cse\.vcdPassword.*oe:value="(.*?)"/)' $ovfenv_filepath)
vcdVerifySsl=$(perl -ne 'print $1,"\n" if (m/cse\.vcdVerifySsl.*oe:value="(.*?)"/)' $ovfenv_filepath)
serviceTelemetry=$(perl -ne 'print $1,"\n" if (m/cse\.serviceTelemetry.*oe:value="(.*?)"/)' $ovfenv_filepath)
brokerOrg=$(perl -ne 'print $1,"\n" if (m/cse\.brokerOrg.*oe:value="(.*?)"/)' $ovfenv_filepath)
brokerOvdc=$(perl -ne 'print $1,"\n" if (m/cse\.brokerOvdc.*oe:value="(.*?)"/)' $ovfenv_filepath)
brokerCatalog=$(perl -ne 'print $1,"\n" if (m/cse\.brokerCatalog.*oe:value="(.*?)"/)' $ovfenv_filepath)
brokerNetwork=$(perl -ne 'print $1,"\n" if (m/cse\.brokerNetwork.*oe:value="(.*?)"/)' $ovfenv_filepath)
brokerStorageProfile=$(perl -ne 'print $1,"\n" if (m/cse\.brokerStorageProfile.*oe:value="(.*?)"/)' $ovfenv_filepath)
brokerRemoteTemplateCookbookUrl=$(perl -ne 'print $1,"\n" if (m/cse\.brokerRemoteTemplateCookbookUrl.*oe:value="(.*?)"/)' $ovfenv_filepath)

# quoting the variables due to potential special characters (such as *, which lists every file when used as `$(*)`)
cse sample -o $config_filepath \
    -x mqtt_verify "$brokerStorageProfile" \
    -x vcd_host "$vcdHost" \
    -x username "$vcdUsername" \
    -x password "$vcdPassword" \
    -x vcd_verify "$vcdVerifySsl" \
    -x enable_telemetry "$serviceTelemetry" \
    -x org_name "$brokerOrg" \
    -x broker.vdc "$brokerOvdc" \
    -x catalog_name "$brokerCatalog" \
    -x broker.network "$brokerNetwork" \
    -x broker.storage_profile "$brokerStorageProfile" \
    -x broker.remote_template_cookbook_url "$brokerRemoteTemplateCookbookUrl"

# perl -ne 'print $1,"\n" if (m/cse\.configUrl.*oe:value="(.*?)"/)' $ovfenv_filepath > /root/configUrl
# wget $(cat /root/configUrl) -O $config_filepath

sed 's/\  enforce_authorization: false/\  enforce_authorization: true/g' $config_filepath > $config_filepath
chmod 600 $config_filepath

perl -ne 'print $1,"\n" if (m/cse\.vcentersNames.*oe:value="(.*?)"/)' $ovfenv_filepath >> /root/vcNames
perl -ne 'print $1,"\n" if (m/cse\.vcentersUsernames.*oe:value="(.*?)"/)' $ovfenv_filepath >> /root/vcUsernames
perl -ne 'print $1,"\n" if (m/cse\.vcentersPasswords.*oe:value="(.*?)"/)' $ovfenv_filepath >> /root/vcPasswords
perl -ne 'print $1,"\n" if (m/cse\.vcentersVerify.*oe:value="(.*?)"/)' $ovfenv_filepath >> /root/vcVerify

python3 /root/set-vcenters.py $config_filepath /root/vcNames /root/vcUsernames /root/vcPasswords /root/vcVerify

cse install -c $config_filepath -s > /root/cse-install-output.log
cse upgrade -c $config_filepath -s > /root/cse-upgrade-output.log
systemctl enable cse
systemctl start cse
echo `date` >> $log_filepath
