set dotenv-load

project := "main"
compose_files := `find stacks -mindepth 2 -maxdepth 2 -name "compose.yml" | sort | xargs -I {} echo -f {}`

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

# Follow logs across all containers or for a specific service (e.g. `just logs photos_backend`)
logs *args:
    just dc logs -f {{args}}

# Execute the backup script
backup:
    @./scripts/backup.sh

# Restore backup for a specific date (e.g. `just restore 2026-10-31`)
restore date:
    @./scripts/restore.sh {{date}}