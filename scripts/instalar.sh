#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y nodejs npm git
cd /opt
rm -rf ARSW_LOAD-BALANCING_AZURE
git clone https://github.com/daprieto1/ARSW_LOAD-BALANCING_AZURE.git
cd ARSW_LOAD-BALANCING_AZURE/FibonacciApp
npm install
cat > /etc/systemd/system/fibonacci.service <<'UNIT'
[Unit]
Description=FibonacciApp
After=network.target
[Service]
WorkingDirectory=/opt/ARSW_LOAD-BALANCING_AZURE/FibonacciApp
ExecStart=/usr/bin/node FibonacciApp.js
Restart=always
User=root
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now fibonacci
sleep 3
echo "Prueba local:"
curl -s http://localhost:3000/fibonacci/6
echo
echo "Servidor:"
hostname
