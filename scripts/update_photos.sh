docker compose \
  -p main \
  -f stacks/photos/compose.yml \
  --project-directory . \
  --env-file .env \
  pull
