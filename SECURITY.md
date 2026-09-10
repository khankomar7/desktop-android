# Security policy

## Supported deployment

This project exposes a complete Linux desktop through a browser. The underlying webtop session includes a terminal and passwordless `sudo` inside the container. It must not be exposed to the public Internet without authentication, HTTPS, and an appropriately configured reverse proxy.

The production Compose file requires `WEBTOP_USER` and `WEBTOP_PASSWORD`. Keep these values in Railway Variables, Docker secrets, or a local `.env` file that is never committed. Use `docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build` only for local development.

The image currently targets `linux/amd64` because the Claude Desktop Linux package is published for amd64. Do not assume arm64 support without a separate build and runtime test.

## Reporting a vulnerability

Do not publish credentials, tokens, private URLs, or a working exploit in a public issue. Contact the repository owner privately through GitHub with reproduction steps, affected commit, impact, and a suggested mitigation.
