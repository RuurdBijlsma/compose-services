#!/bin/bash
docker compose \
    -p main \
    -f stacks/monitoring/compose.yml \
    -f stacks/proxy/compose.yml \
    -f stacks/media/compose.yml \
    -f stacks/vault/compose.yml \
    --project-directory . \
    --env-file .env \
    up