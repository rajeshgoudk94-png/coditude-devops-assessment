#!/bin/bash
set -euo pipefail
systemctl daemon-reload
systemctl enable coditude-backend
systemctl restart coditude-backend
