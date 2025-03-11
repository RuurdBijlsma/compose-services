#!/bin/bash
docker compose \
	-f stacks/monitoring/compose.yml \
	-f stacks/proxy/compose.yml \
	-f stacks/media/compose.yml \
	--env-file .env \
	up -d
