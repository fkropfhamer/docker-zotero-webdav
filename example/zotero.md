# Tutorial: Zotero Syncing with WebDAV

> Original Blog Post: [Zotero Syncing Across Devices with WebDAV (Docker)](https://blog.baksili.codes/zotero-webdav)

As a researcher or student, having your Zotero library accessible across all your devices is essential for a seamless workflow. While Zotero's built-in syncing is convenient, setting up a custom WebDAV server offers enhanced flexibility and control. In this article, we'll explore how WebDAV enables smooth Zotero syncing and guide you through the setup process.


## WebDAV for Zotero Syncing

WebDAV is a protocol that enables you to work with files on remote servers. It's an extension of the HTTP protocol, developed in the late 1990s to facilitate collaborative editing and file management on the web.

[Zotero Syncing](https://www.zotero.org/support/sync) leverages WebDAV as a backend for storage, offering several advantages:

1. **Native File Storage**: Unlike Zotfile with linked files, WebDAV allows you to store your Zotero files natively, making access and management straightforward.
2. **Global Access**: Whether you're at home or on the go, you can access your Zotero database from anywhere using a VPN like Zerotier or Surge Ponte, or by publishing your server online.
3. **Smooth Syncing**: WebDAV ensures that your research and citations stay up-to-date across all your devices without any hiccups.

## Self-host Your WebDAV Server

You can set up your WebDAV server on a NAS (Network Attached Storage) device in your homelab or on a dedicated server. To get started, you'll need a Docker container running a WebDAV server.

https://github.com/BaksiLi/docker-webdav

Here's a simple `docker-compose.yaml` setup:

```yaml
version: '3'

services:
  nginx-webdav:
    image: baksili/webdav-server:latest
    container_name: webdav-zotero
    restart: unless-stopped
    ports:
      - "15801:80/tcp"
    volumes:
      - "/path/to/your/zotero/data:/media/data/zotero"
      - "./letsencrypt:/etc/letsencrypt"
    environment:
      - USERNAME=<your-username>
      - PASSWORD=<your-password>

    healthcheck:
      test: ["CMD", "curl", "-f", "<http://localhost>"]
      interval: 30s
      timeout: 10s
      retries: 3

    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 256M

```

Replace `/path/to/your/zotero/data` with your actual Zotero data path and set your preferred `USERNAME` and `PASSWORD`.

If ports 80 or 443 are already in use on your system, you can specify an alternative port by modifying the `ports` section in the `docker-compose.yaml` file. For example, you can use port 15801 for HTTP by setting `15801:80/tcp`.

## Configuring Zotero for WebDAV Sync

Once your server is up and running, configuring Zotero to sync with it is a breeze:

1. Open Zotero and navigate to "Edit" > "Preferences" > "Sync".
2. In “File Syncing”, tick “Sync attachment […]” and choose "WebDAV" as your sync method.
3. Enter your WebDAV server URL (e.g., `http://your-domain.com:15801`).
4. Input your WebDAV username and password.
5. Click "Verify Server" to ensure everything's set up correctly.

![image](https://github.com/user-attachments/assets/685ce61f-b4c6-493d-b45d-768f6a6c9fd9)

With these steps, your Zotero library will sync effortlessly using your WebDAV server, keeping your research accessible and organized wherever you are.

## Conclusion

By leveraging WebDAV for Zotero syncing, you gain the advantage of native file storage and the flexibility to access your Zotero library from anywhere. The setup process is straightforward, and the smooth syncing ensures that your research and citations are always up-to-date across all your devices. Embrace the power of WebDAV and take your Zotero workflow to the next level!
