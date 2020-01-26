#!/bin/bash

app_ip=`cd ../terraform/stage && terraform output app_external_ip`
db_ip=`cd ../terraform/stage && terraform output db_external_ip`

if [ "$1" == "--list" ] ; then
cat<<EOF
{
    "app_servers": {
        "hosts": [$app_ip],
    },
    "db_servers": [$db_ip],
}
EOF
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
