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
  baksili/webdav-server:latest
```

Replace `/path/to/your/data` with the actual path to the directory you want to serve, and set the desired `USERNAME` and `PASSWORD` for authentication.

### Using `docker-compose` (recommended)

1. Create a `docker-compose.yaml` file ([example](./docker-compose.yaml)) with the following content:

```yaml
version: '3'

services:
  webdav:
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

or if you want to build the image yourself, `docker-compose --build -d up`.

#### SSL/TLS Support
To enable SSL/TLS support, enable the port used:

```yaml
    ports:
      - "80:80/tcp"
      - "443:443/tcp"
```

Uncomment the `VIRTUAL_HOST` and `LETSENCRYPT_EMAIL` environment variables in the `docker-compose.yaml` file and provide the appropriate values:

- `VIRTUAL_HOST`: Your domain name.
- `LETSENCRYPT_EMAIL`: Your email address for Let's Encrypt certificate generation.

Uncomment the following line in the `volumes` section to persist the generated SSL certificates:

```yaml
- "./letsencrypt:/etc/letsencrypt"
```

The container will automatically generate and configure SSL certificates using Certbot and Let's Encrypt.

#### Healthcheck
The `healthcheck` section in the `docker-compose.yaml` file ensures that the container is running and responsive. It sends an HTTP request to `http://localhost` every 30 seconds to check the container's health.

## Use Cases

### Zotero Syncing

WebDAV is an excellent choice for syncing your Zotero library across multiple devices. It offers native file storage, global access, and smooth syncing. Follow the tutorial in [example/zotero.md](example/zotero.md) to set up Zotero syncing with your WebDAV server.

### File Sharing and Collaboration

WebDAV provides a simple and efficient way to share files and collaborate with others. By setting up a WebDAV server, you can create a centralized repository for your team to store and access files from anywhere.

### Backup and Storage

Use WebDAV as a backup solution for your important files. With the ability to access your files remotely, you can ensure that your data is safe and secure, even if your local device fails.
