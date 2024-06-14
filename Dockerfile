# Use an official PostgreSQL image as the base
FROM postgres:latest

# Set environment variables for PostgreSQL
ENV POSTGRES_DB=acebook_springboot_development
ENV POSTGRES_USER=testuser
ENV POSTGRES_PASSWORD=testpassword

# Copy your application files to the container
COPY . /usr/src/app

# Set the working directory
WORKDIR /usr/src/app

# Install Maven and other dependencies
RUN apt-get update && \
    apt-get install -y maven openjdk-17-jdk

# Install application dependencies and package the application
RUN mvn install -DskipTests

# Expose the ports
EXPOSE 5432
EXPOSE 8080

# Run the application
CMD ["mvn", "spring-boot:run"]