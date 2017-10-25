#!/bin/bash

if ! [[ $(id -u) = 0 ]]; then
	echo you must run this script as root
	exit 1
fi

echo ... configuring node_exporter
curl -sLO https://github.com/prometheus/node_exporter/releases/download/v0.15.0/node_exporter-0.15.0.linux-amd64.tar.gz
tar -xvzf node_exporter-*.tar.gz

echo ... deleting node_exporter tarball
rm ./node_exporter-*.tar.gz

mv ./node_exporter-* /usr/local/bin/node_exporter

echo ... creating a new user for prometheus node_exporter
useradd promusr
chown -R promusr:promusr /usr/local/bin/node_exporter

echo ... creating the systemd service
cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Prometheus service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/node_exporter/node_exporter
User=promusr
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter
