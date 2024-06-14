#!/bin/sh

# Function to check if the database schema exists
check_db_schema() {
  PGPASSWORD=$SPRING_DATASOURCE_PASSWORD psql -h $SPRING_DATASOURCE_URL -U $SPRING_DATASOURCE_USERNAME -d $SPRING_DATASOURCE_DBNAME -c '\dt' | grep -q 'No relations found'
  return $?
}

# Initialize the database schema if it doesn't exist
if check_db_schema; then
  echo "Database schema not found, running Flyway migrations..."
  mvn flyway:migrate
else
  echo "Database schema already exists, skipping Flyway migrations..."
fi

# Start the application
mvn spring-boot:run