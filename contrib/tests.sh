#!/bin/bash
set -e
cd "$(dirname "$0")/.."

python3 -m venv venv
source ./venv/bin/activate
python3 -c "import sys;print(sys.executable)"
pip install pytest-testinfra
