set dotenv-load

project := "main"
compose_files := `find stacks -mindepth 2 -maxdepth 2 -name "compose.yml" | sort | sed 's/^/-f /' | tr '\n' ' '`

# List available commands
default:
    @just --list

# Ensure external proxy network exists
[private]
ensure-network:
    @docker network create proxy-net 2>/dev/null || true

# Execute raw docker compose across all stacks (e.g. `just dc ps`, `just dc top`)
dc *args:
    docker compose -p {{project}} {{compose_files}} --project-directory . --env-file .env {{args}}

# Start all stacks in the background
up: ensure-network
    just dc up -d --remove-orphans

# Stop all stacks
down:
    just dc down

# Restart all stacks
restart: down up

# Pull latest images and recreate all containers
pull-all:
    just dc pull
    just up
    docker image prune -f

# Pull and restart a specific stack (e.g. `just pull photos` or `just pull media`)
pull stack:
    docker compose -p {{project}} -f stacks/{{stack}}/compose.yml --project-directory . --env-file .env pull
    docker compose -p {{project}} -f stacks/{{stack}}/compose.yml --project-directory . --env-file .env up -d
    docker image prune -f

# Check status of containers
ps:
    just dc ps

# Follow logs (supports container name, stack name, service name, or all)
logs *args:
    #!/usr/bin/env bash
    if [ $# -eq 0 ]; then
        just dc logs -f
    elif [ -d "stacks/$1" ]; then
        docker compose -p {{project}} -f "stacks/$1/compose.yml" --project-directory . --env-file .env logs -f "${@:2}"
    elif docker inspect "$1" >/dev/null 2>&1; then
        docker logs -f "$@"
    else
        just dc logs -f "$@"
    fi

# Execute the backup script
backup:
    @./scripts/backup.sh

# Restore backup for a specific date (e.g. `just restore 2026-10-31`)
restore date:
    @./scripts/restore.sh {{date}}