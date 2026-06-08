# Adoptions

A Spring Boot 4 + Spring AI sample application that uses Anthropic and PostgresML to power a dog adoption assistant.

## Requirements

- Java 25
- Docker
- An Anthropic API key

## Run locally

1. Start PostgresML:

   ```bash
   ./adoptions/db/run.sh
   ```

2. Start the scheduler MCP server:

   ```bash
   cd scheduler
   ./mvnw spring-boot:run
   ```

   This starts the MCP server on http://localhost:8081.

3. Start the assistant application:

   ```bash
   cd adoptions
   ./mvnw spring-boot:run
   ```

4. Open the application and try the assistant:

   - Metrics: http://localhost:8080/actuator/metrics
   - Ask for available dogs: http://localhost:8080/jlong/assistant?question=do%20you%20have%20any%20neurotic%20dogs%3F
   - Then schedule Prancer: http://localhost:8080/jlong/assistant?question=fantastic.%20when%20can%20i%20schedule%20an%20appointment%20to%20pickup%20Prancer%20from%20the%20New%20York%20City%20location%3F

The second request should cause the assistant to invoke the scheduling tool and return a date three days in the future.

## Open in GitHub Codespaces

This repository includes Codespaces configuration for Java, Docker, and VS Code debugging.

### First start

When the Codespace is created:

- the devcontainer installs Java tooling
- Docker-in-Docker is enabled
- a PostgresML container is started automatically
- the database role from adoptions/db/users.sql is initialized

### Set your API key

Create or edit:

```bash
adoptions/.env
```

Add:

```dotenv
ANTHROPIC_API_KEY=your_key_here
ANTHROPIC_MODEL=claude-haiku-4-5
```

If your Anthropic account does not have access to that model, set `ANTHROPIC_MODEL` to one your account can use.

If adoptions/.env does not exist yet, it will be copied automatically from adoptions/.env.example.

### Run the app in Codespaces

Use either of these approaches:

#### Option 1: Terminal

Start the scheduler MCP server first:

```bash
cd scheduler
./mvnw spring-boot:run
```

Then start the assistant application in a second terminal:

```bash
cd adoptions
./mvnw spring-boot:run
```

#### Option 2: VS Code debugger

Open **Run and Debug** and start:

- `Debug AdoptionsApplication`

That launch configuration runs com.example.adoptions.AdoptionsApplication and should load environment variables from adoptions/.env.

### Forwarded ports

Codespaces forwards these ports:

- `8080` - Spring Boot app
- `5433` - PostgresML PostgreSQL
- `8000` - PostgresML HTTP endpoint

## Database notes

The application is configured to connect to:

- JDBC URL: `jdbc:postgresql://localhost:5433/postgresml`
- Username: `myappuser`
- Password: `mypassword`

These values match adoptions/src/main/resources/application.properties and the bootstrap scripts.

The Spring Boot application is in the adoptions subdirectory, so the properties file is at adoptions/src/main/resources/application.properties.

## Useful commands

Start dependencies manually:

```bash
./adoptions/db/run.sh
```

Run the app:

```bash
cd adoptions
./mvnw spring-boot:run
```

Run tests:

```bash
cd adoptions
./mvnw test
```
