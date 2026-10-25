#!/usr/bin/env bash
set -euo pipefail
python -m compileall apps/backend
python -m pip install -r apps/backend/requirements.txt pytest
pytest -q apps/backend/test_main.py
if command -v cfn-lint >/dev/null 2>&1; then cfn-lint infra/templates/*.yaml; else echo "cfn-lint not installed; install it to validate CloudFormation."; fi
if command -v npm >/dev/null 2>&1; then (cd apps/frontend && npm install && npm run build); else echo "Node.js/npm not installed; frontend build skipped."; fi
