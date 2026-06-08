# Adoptions

A Spring Boot 4 + Spring AI sample application that uses Anthropic and PostgresML to power a dog adoption assistant.

## Requirements

- Java 21
- Docker
- An Anthropic API key

## Run locally

1. Start PostgresML:

   ```bash
   chmod +x db/run.sh
   ./db/run.sh
   ```

2. Export your Anthropic API key:

   ```bash
   export ANTHROPIC_API_KEY=your_key_here
   ```

3. Start the application:

   ```bash
   ./mvnw spring-boot:run
   ```

4. Open the application:

   - App: http://localhost:8080
   - Example request: http://localhost:8080/jlong/assistant?question=do%20you%20have%20any%20neurotic%20dogs%3F

## Open in GitHub Codespaces

This repository includes Codespaces configuration for Java, Docker, and VS Code debugging.

### First start

When the Codespace is created:

- the devcontainer installs Java tooling
- Docker-in-Docker is enabled
- a PostgresML container is started automatically
- the database role from `db/users.sql` is initialized

### Set your API key

Create or edit:

```bash
.env
```

Add:

```dotenv
ANTHROPIC_API_KEY=your_key_here
ANTHROPIC_MODEL=claude-3-7-sonnet-20250219
```

If your Anthropic account does not have access to that model, set `ANTHROPIC_MODEL` to one your account can use.

If `.env` does not exist yet, it will be copied automatically from `.env.example`.

### Run the app in Codespaces

Use either of these approaches:

#### Option 1: Terminal

```bash
./mvnw spring-boot:run
```

#### Option 2: VS Code debugger

Open **Run and Debug** and start:

- `Debug AdoptionsApplication`

That launch configuration runs `com.example.demo.AdoptionsApplication` and should load environment variables from `.env`.

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

These values match `src/main/resources/application.properties` and the bootstrap scripts.

## Useful commands

Start dependencies manually:

```bash
./db/run.sh
```

Run the app:

```bash
./mvnw spring-boot:run
```

Run tests:

```bash
./mvnw test
```
