#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for PostgreSQL to be ready
until pg_isready -h db -p 5432; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

# If the database doesn't exist, create it
if ! bundle exec rails db:version > /dev/null 2>&1; then
  echo "Database does not exist, creating..."
  bundle exec rails db:create
fi

# Run pending migrations
echo "Running migrations..."
bundle exec rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"