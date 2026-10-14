#!/bin/zsh
# macOS launcher for the project-local Python environment.
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
exec "$SCRIPT_DIR/.venv/bin/python" "$SCRIPT_DIR/gui.py"
