# WebDAV Server Docker

A secure, fast, and lightweight WebDAV Server, built from the official Nginx image with minimal configuration.

## How to use this image

### Using `docker run`

```console
$ docker run -d \
  --name webdav \
  -p 80:80 \
  -v /path/to/your/data:/media/data \
  -e USERNAME=<your-username> \
  -e PASSWORD=<your-password> \
  ghcr.io/fkropfhamer/docker-webdav:main
```

Set file permissions.

`sudo chmod -R 664 /path/to/your/data`
`sudo chown -R www-data:your-host-username /path/to/your/data`

Replace `/path/to/your/data` with the actual path to the directory you want to serve, and set the desired `USERNAME` and `PASSWORD` for authentication.

### Using `docker-compose` (recommended)

1. Create a `docker-compose.yaml` file ([example](./docker-compose.yaml)) with the following content:

```yaml
services:
  webdav:
    image: ghcr.io/fkropfhamer/docker-webdav:main
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
$ docker compose up -d
```

or if you want to build the image yourself, `docker compose --build -d up`.

#### Healthcheck
The `healthcheck` section in the `docker-compose.yaml` file ensures that the container is running and responsive. It sends an HTTP request to `http://localhost` every 30 seconds to check the container's health.
