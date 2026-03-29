-- Create the database
CREATE DATABASE fixnow;

-- Connect to the database
\c fixnow;

-- Spring Boot with 'spring.jpa.hibernate.ddl-auto=update' will automatically
-- create all the necessary tables (users, services, providers, bookings, reviews, etc.)
-- when the application starts up.

-- You can optionally grant all privileges to a specific user if you aren't using postgres
-- GRANT ALL PRIVILEGES ON DATABASE fixnow TO "your_username";
