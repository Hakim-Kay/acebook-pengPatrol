#!/bin/bash
set -e

# Check if the database schema already exists
if psql -h $RENDER_DB_HOST -U $RENDER_DB_USERNAME -d $RENDER_DB_NAME -c '\dt' | grep -q 'No relations found.'; then
  echo "Database schema does not exist. Running Flyway migrations..."
  mvn flyway:migrate
else
  echo "Database schema already exists, skipping Flyway migrations..."
fi

# Start the application
mvn spring-boot:run