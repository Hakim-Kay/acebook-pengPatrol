# Use an official PostgreSQL image as the base
FROM postgres:latest as db

# Set environment variables for PostgreSQL
ENV POSTGRES_DB=acebook_springboot_development
ENV POSTGRES_USER=testuser
ENV POSTGRES_PASSWORD=testpassword

# Copy the SQL scripts for initializing the database
COPY sql/ /docker-entrypoint-initdb.d/

# Use an official Maven image to build the application
FROM maven:3.8.4-openjdk-17-slim as builder

# Set the working directory
WORKDIR /usr/src/app

# Copy your application files to the container
COPY . .

# Install application dependencies and package the application
RUN mvn clean install -DskipTests

# Use an official openjdk image to run the application
FROM openjdk:17-jdk-slim

# Install dependencies including PostgreSQL client and Maven
RUN apt-get update && \
    apt-get install -y postgresql-client maven

# Set the working directory
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /usr/src/app .

# Copy entrypoint script from the scripts directory
COPY scripts/entrypoint.sh /app/scripts/

# Make entrypoint script executable
RUN chmod +x /app/scripts/entrypoint.sh

# Expose the ports
EXPOSE 5432
EXPOSE 8080

# Set the entrypoint to the custom script
ENTRYPOINT ["/app/scripts/entrypoint.sh"]