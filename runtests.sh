export bigip_pip=`terraform output --json | jq -cr '.bigip_pip.value[]'`
export BIGIP_PASSWORD=$(terraform output --json | jq '.bigip_password.value' -cr|awk -F \" '{print $2}')
export BIGIP_USER="admin"
export DO_VERSION=1.15.0
export AS3_VERSION=3.22.1
export TS_VERSION=1.14.0
for ip in $bigip_pip; do inspec exec bigip --reporter cli --show-progress --input bigip_address=$ip bigip_port=443 user=$BIGIP_USER password=$BIGIP_PASSWORD do_version=$DO_VERSION as3_version=$AS3_VERSION ts_version=$TS_VERSION; done
