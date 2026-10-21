#!/bin/bash
set -e

# Navigate to the repository root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "==> Pulling latest images for photos stack..."
docker compose \
  -p main \
  -f stacks/photos/compose.yml \
  --project-directory . \
  --env-file .env \
  pull

echo "==> Recreating photos containers with updated images..."
docker compose \
  -p main \
  -f stacks/photos/compose.yml \
  --project-directory . \
  --env-file .env \
  up -d

echo "==> Cleaning up dangling/old images..."
docker image prune -f

echo "==> Photos stack has been successfully updated!"