cp cse-ovf/appliance.json .
cp cse-ovf/customizations.json .
cp cse-ovf/pre-install.sh .
cp cse-ovf/post-install.sh .
cap build -f appliance.json
