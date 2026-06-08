#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -f .devcontainer/.env && -f .devcontainer/.env.example ]]; then
  cp .devcontainer/.env.example .devcontainer/.env
  echo "Created .devcontainer/.env from .devcontainer/.env.example"
fi

echo "post-create complete"