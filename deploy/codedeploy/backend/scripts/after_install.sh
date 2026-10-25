#!/bin/bash
set -euo pipefail
cd /opt/coditude/backend/current
python3.12 -m venv /opt/coditude/backend/venv
/opt/coditude/backend/venv/bin/pip install --upgrade pip
/opt/coditude/backend/venv/bin/pip install -r requirements.txt
cat >/etc/systemd/system/coditude-backend.service <<'UNIT'
[Unit]
Description=Coditude FastAPI backend
After=network-online.target
Wants=network-online.target
[Service]
User=ec2-user
Group=ec2-user
WorkingDirectory=/opt/coditude/backend/current
EnvironmentFile=-/etc/coditude/backend.env
ExecStart=/opt/coditude/backend/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=5
NoNewPrivileges=true
[Install]
WantedBy=multi-user.target
UNIT
chown -R ec2-user:ec2-user /opt/coditude/backend
