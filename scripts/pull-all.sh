#!/bin/bash
set -e

# Navigate to the repository root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Find all compose.yml files across the stacks
COMPOSE_FILES=$(find stacks -mindepth 2 -maxdepth 2 -name "compose.yml" | sort | xargs -I {} echo -f {})

echo "==> Pulling latest images for all stacks..."
docker compose \
    -p main \
    $COMPOSE_FILES \
    --project-directory . \
    --env-file .env \
    pull

echo "==> Recreating containers with updated images..."
docker compose \
    -p main \
    $COMPOSE_FILES \
    --project-directory . \
    --env-file .env \
    up -d --remove-orphans

echo "==> Cleaning up dangling/old images..."
docker image prune -f

echo "==> All services have been successfully updated!"