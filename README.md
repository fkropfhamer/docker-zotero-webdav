# WebDav Server Docker

A secure, fast, and lightweight WebDav Server, built from the official Nginx image with minimal configuration.

## How to use this image

1. Create a `docker-compose.yaml` file with the following content:

```yaml
version: '3'

services:
  nginx-webdav:
    image: baksili/webdav-server:latest
    container_name: webdav
    restart: unless-stopped
    ports:
      - "80:80/tcp"
    volumes:
      - "/path/to/your/data:/media/data"
    environment:
      - USERNAME=<your-username>
      - PASSWORD=<your-password>

    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s

```

2. Replace `/path/to/your/data` with the actual path to the directory you want to serve.

3. Set the desired `USERNAME` and `PASSWORD` for authentication.

4. Run the following command to start the container:

```console
$ docker-compose up -d
```

## Volumes
- `/media/data` - The directory to be served by WebDav.

## Authentication
To restrict access to authorized users, define the `USERNAME` and `PASSWORD` environment variables in the `docker-compose.yaml` file.

## SSL/TLS Support
To enable SSL/TLS support, uncomment the `VIRTUAL_HOST` and `LETSENCRYPT_EMAIL` environment variables in the `docker-compose.yaml` file and provide the appropriate values:

- `VIRTUAL_HOST`: Your domain name.
- `LETSENCRYPT_EMAIL`: Your email address for Let's Encrypt certificate generation.

Uncomment the following line in the `volumes` section to persist the generated SSL certificates:

```yaml
- "./letsencrypt:/etc/letsencrypt"
```

The container will automatically generate and configure SSL certificates using Certbot and Let's Encrypt.

## Healthcheck
The `healthcheck` section in the `docker-compose.yaml` file ensures that the container is running and responsive. It sends an HTTP request to `http://localhost` every 30 seconds to check the container's health.

(Inspired by https://github.com/jbbodart/alpine-nginx-webdav)
