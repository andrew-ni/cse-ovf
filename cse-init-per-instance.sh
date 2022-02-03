#!/bin/bash

echo `date` >> /root/cse-init-per-instance.log
# order matters here: gcc needs mpc installed first
rpm -Uvvh /var/cache/tdnf/photon-updates/rpms/x86_64/*.rpm >> /root/cse-init-per-instance.log
rpm -Uvvh /var/cache/tdnf/photon/rpms/x86_64/*.rpm >> /root/cse-init-per-instance.log
rpm -Uvvh /var/cache/tdnf/photon-updates/rpms/noarch/*.rpm >> /root/cse-init-per-instance.log

pip3 install --upgrade /root/pip-21.3.1-py3-none-any.whl >> /root/cse-init-per-instance.log
pip3 install --ignore-installed /root/container_service_extension-3.1.2.dev46-py3-none-any.whl >> /root/cse-init-per-instance.log

vmtoolsd --cmd "info-get guestinfo.ovfenv" > /root/ovfenv

# unused
perl -ne 'print $1,"\n" if (m/cse\.brokerIpAllocationMode.*oe:value="(.*?)"/)' /root/ovfenv >> /root/cse-properties
perl -ne 'print $1,"\n" if (m/cse\.brokerRemoteTemplateCookbookUrl.*oe:value="(.*?)"/)' /root/ovfenv >> /root/cse-properties
perl -ne 'print $1,"\n" if (m/cse\.vcdPort.*oe:value="(.*?)"/)' /root/ovfenv >> /root/cse-properties
perl -ne 'print $1,"\n" if (m/cse\.serviceProcessors.*oe:value="(.*?)"/)' /root/ovfenv >> /root/cse-properties

cse sample -o /root/cse-config.yaml \
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
    -x broker.storage_profile $(perl -ne 'print $1,"\n" if (m/cse\.brokerStorageProfile.*oe:value="(.*?)"/)' /root/ovfenv)

# perl -ne 'print $1,"\n" if (m/cse\.configUrl.*oe:value="(.*?)"/)' /root/ovfenv > /root/configUrl
# wget $(cat /root/configUrl) -O /root/cse-config.yaml

chmod 600 /root/cse-config.yaml
cse install -c /root/cse-config.yaml -s > /root/cse-install-output.log
cse upgrade -c /root/cse-config.yaml -s > /root/cse-upgrade-output.log
systemctl enable cse
systemctl start cse
echo `date` >> /root/cse-init-per-instance.log
