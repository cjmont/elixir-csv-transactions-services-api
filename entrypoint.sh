# entrypoint.sh
#!/bin/sh

# Exit on failures
set -e

# Wait until Postgres is ready
until pg_isready -h db -p 5432 -U postgres; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - continuing"

# Create, migrate and seed database if it doesn't exist
mix ecto.create
mix ecto.migrate

# Start the Phoenix server
exec mix phx.server
