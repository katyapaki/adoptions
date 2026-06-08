DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'myappuser') THEN
		CREATE ROLE myappuser WITH LOGIN PASSWORD 'mypassword';
	END IF;
END
$$;

SELECT 'CREATE DATABASE myappdb OWNER myappuser'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'myappdb')
\gexec

GRANT ALL PRIVILEGES ON DATABASE myappdb TO myappuser;
GRANT ALL PRIVILEGES ON DATABASE postgresml TO myappuser;
GRANT USAGE ON SCHEMA public TO myappuser;
GRANT CREATE ON SCHEMA public TO myappuser;
GRANT USAGE ON SCHEMA public TO myappuser;

DO $$
BEGIN
	IF EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'pgml') THEN
		GRANT CREATE ON SCHEMA pgml TO myappuser;
		GRANT USAGE ON SCHEMA pgml TO myappuser;
	END IF;
END
$$;