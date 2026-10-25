#!/bin/bash
set -euo pipefail
if ! systemctl is-active --quiet codedeploy-agent; then
  dnf install -y ruby wget
  cd /tmp
  REGION="${AWS_REGION:-us-east-1}"
  wget -q "https://aws-codedeploy-${REGION}.s3.${REGION}.amazonaws.com/latest/install" -O install
  chmod +x install
  ./install auto
fi
systemctl enable codedeploy-agent
systemctl start codedeploy-agent
