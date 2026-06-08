#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker CLI not found; skipping database startup"
  exit 0
fi

echo "Waiting for docker daemon to become ready..."
for _ in $(seq 1 60); do
  if docker info >/dev/null 2>&1; then
    ./db/run.sh
    exit 0
  fi
  sleep 2
done

echo "docker daemon did not become ready in time"
exit 1