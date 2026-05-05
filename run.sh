#!/usr/bin/env bash
# Yandex Mail MCP server entry point.
# Resolves repo dir, activates .venv if present, runs server.py.
# Used by .mcp.json / claude_desktop_config.json as a single command.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -x "$REPO_DIR/.venv/bin/python" ]]; then
    PYTHON="$REPO_DIR/.venv/bin/python"
elif command -v python3 >/dev/null 2>&1; then
    PYTHON="python3"
else
    echo "run.sh: python3 not found and $REPO_DIR/.venv missing" >&2
    exit 1
fi

exec "$PYTHON" "$REPO_DIR/server.py" "$@"
