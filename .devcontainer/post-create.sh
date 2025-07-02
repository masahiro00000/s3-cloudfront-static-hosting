# .devcontainer/post-create.sh
#!/usr/bin/env bash
set -euo pipefail

sudo chown -R $USER:$USER /workspaces

git config --local core.autocrlf input



