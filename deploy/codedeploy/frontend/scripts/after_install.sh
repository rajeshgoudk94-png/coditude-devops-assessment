#!/bin/bash
set -euo pipefail
cat >/etc/systemd/system/coditude-frontend.service <<'UNIT'
[Unit]
Description=Coditude Next.js frontend
After=network-online.target
Wants=network-online.target
[Service]
User=ec2-user
Group=ec2-user
WorkingDirectory=/opt/coditude/frontend/current
Environment=NODE_ENV=production
Environment=PORT=3000
EnvironmentFile=-/etc/coditude/frontend.env
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=5
NoNewPrivileges=true
[Install]
WantedBy=multi-user.target
UNIT
chown -R ec2-user:ec2-user /opt/coditude/frontend
