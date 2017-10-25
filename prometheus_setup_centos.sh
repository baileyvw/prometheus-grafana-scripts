#!/bin/bash

if ! [[ $(id -u) = 0 ]]; then
	echo you must run this script as root
	exit 1
fi

echo ... configuring prometheus
curl -sLO https://github.com/prometheus/prometheus/releases/download/v1.8.0/prometheus-1.8.0.linux-amd64.tar.gz
tar -xvzf prometheus-*.tar.gz

echo ... deleting prometheus tarball
rm ./prometheus-*.tar.gz

mv ./prometheus-* /usr/local/bin/prometheus

echo ... creating a new user for prometheus
useradd promusr
chown -R promusr:promusr /usr/local/bin/prometheus

echo ... creating the systemd service
cat > /etc/systemd/system/prometheus.service << EOF
[Unit]
Description=Prometheus service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/prometheus/prometheus -config.file=/usr/local/bin/prometheus/prometheus.yml -storage.local.path=/usr/local/bin/prometheus/data
User=promusr
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

cat >> /usr/local/bin/prometheus/prometheus.yml << EOF

  - job_name: 'azure machines'
    file_sd_configs:
      - files:
          - /usr/local/bin/prometheus/target_hosts.yml
EOF

touch /usr/local/bin/prometheus/target_hosts.yml
chown promusr:promusr /usr/local/bin/prometheus/target_hosts.yml

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
