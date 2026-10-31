set dotenv-load

project := "main"
compose_files := `find stacks -mindepth 2 -maxdepth 2 -name "compose.yml" | sort | xargs -I {} echo -f {}`

# Run docker compose with all stacks
dc *args:
    docker compose -p {{project}} {{compose_files}} --project-directory . --env-file .env {{args}}

# Start all stacks
up:
    docker network create proxy-net 2>/dev/null || true
    just dc up -d --remove-orphans

# Stop all stacks
down:
    just dc down

# Restart all stacks
restart: down up

# Pull updates and recreate all containers
pull-all:
    just dc pull
    just up
    docker image prune -f

# Pull and recreate a specific stack (e.g. `just pull photos` or `just pull media`)
pull stack:
    docker compose -p {{project}} -f stacks/{{stack}}/compose.yml --project-directory . --env-file .env pull
    docker compose -p {{project}} -f stacks/{{stack}}/compose.yml --project-directory . --env-file .env up -d
    docker image prune -f

# View live logs across all stacks or specific service
logs *args:
    just dc logs -f {{args}}