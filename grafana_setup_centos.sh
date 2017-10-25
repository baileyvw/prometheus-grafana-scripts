#!/bin/bash

if ! [[ $(id -u) = 0 ]]; then
	echo you must run this script as root
	exit 1
fi

echo ... installing grafana
yum install https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-4.5.2-1.x86_64.rpm -y

systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server
