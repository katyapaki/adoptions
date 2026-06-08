#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="adoptions-postgresml"
IMAGE_NAME="ghcr.io/postgresml/postgresml:2.9.3"
VOLUME_NAME="adoptions-postgresml-data"
HOST_DB_PORT="${HOST_DB_PORT:-5433}"
HOST_HTTP_PORT="${HOST_HTTP_PORT:-8000}"
KEEPALIVE_CMD='["sleep","infinity"]'

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required"
  exit 1
fi

if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  EXISTING_CMD="$(docker inspect --format '{{json .Config.Cmd}}' "$CONTAINER_NAME")"
  if [[ "$EXISTING_CMD" != "$KEEPALIVE_CMD" ]]; then
    echo "Recreating '$CONTAINER_NAME' with persistent command..."
    docker rm -f "$CONTAINER_NAME" >/dev/null
  fi
fi

if docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container '$CONTAINER_NAME' is already running."
elif docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Starting existing container '$CONTAINER_NAME'..."
  docker start "$CONTAINER_NAME" >/dev/null
else
  echo "Creating and starting '$CONTAINER_NAME' from $IMAGE_NAME..."
  docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -v "$VOLUME_NAME":/var/lib/postgresql \
    -p "$HOST_DB_PORT":5432 \
    -p "$HOST_HTTP_PORT":8000 \
    "$IMAGE_NAME" sleep infinity >/dev/null
fi

echo "Waiting for PostgresML to accept connections on port $HOST_DB_PORT..."
for _ in $(seq 1 60); do
  if docker exec -u postgresml "$CONTAINER_NAME" pg_isready -U postgresml -d postgresml >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

if ! docker exec -u postgresml "$CONTAINER_NAME" pg_isready -U postgresml -d postgresml >/dev/null 2>&1; then
  echo "PostgresML did not become ready in time."
  exit 1
fi

echo "Ensuring application role exists..."
cat "$(dirname "$0")/users.sql" | docker exec -i -u postgresml "$CONTAINER_NAME" psql -v ON_ERROR_STOP=1 -U postgresml -d postgresml >/dev/null

echo
echo "PostgresML is ready."
echo "  container: $CONTAINER_NAME"
echo "  database : jdbc:postgresql://localhost:$HOST_DB_PORT/postgresml"
echo "  username : myappuser"
echo "  password : mypassword"
echo "  http api : http://localhost:$HOST_HTTP_PORT"
