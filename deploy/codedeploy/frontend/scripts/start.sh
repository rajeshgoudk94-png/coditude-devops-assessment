#!/bin/bash
set -euo pipefail
systemctl daemon-reload
systemctl enable coditude-frontend
systemctl restart coditude-frontend
