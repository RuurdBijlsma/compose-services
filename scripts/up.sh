# up.sh
#!/bin/bash
set -e

# Get all compose files
COMPOSE_FILES=$(find stacks -mindepth 2 -maxdepth 2 -name "compose.yml" | sort | xargs -I {} echo -f {})

docker compose \
    $COMPOSE_FILES \
    --project-directory files \
    --env-file .env \
    up -d
