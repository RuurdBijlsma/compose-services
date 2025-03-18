# down.sh
#!/bin/bash
set -e

COMPOSE_FILES=$(find stacks -mindepth 2 -maxdepth 2 -name "compose.yml" | sort | xargs -I {} echo -f {})

docker compose \
    $COMPOSE_FILES \
    --project-directory files \
    --env-file .env \
    down
