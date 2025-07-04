# Dockerized Acestream

[Leer documentación en Español](README_es.md)

This project deploys Acestream within a Docker container using Ubuntu 22.04 and Python 3.10 for compatibility.

Acestream is a platform for live streaming via peer-to-peer networks. Dockerizing Acestream simplifies its setup and provides isolated environments.

## Prerequisites

1. **Docker Installation**: Ensure Docker Desktop is installed on your system.
   - [Docker Products Page](https://www.docker.com/products/docker-desktop)
   - [Official Documentation](https://docs.docker.com/get-docker/)

## Automatic Installation and Execution with Setup Scripts (Windows)

### Language Selection
Choose the setup script based on your preferred language:

- **🇺🇸 English**: Use `SetupAcestream.bat`
- **🇪🇸 Español**: Use `SetupAcestream_es.bat`

Both scripts have **identical functionality** and only differ in the interface language.

### Script Overview
The setup scripts automate the following tasks:

   - Checking for Docker installation and operational status.
   - Downloading the latest Acestream Docker image.
   - Setting up the container with dynamic port assignment (to avoid conflicts).
   - Updating the `docker-compose.yml` file dynamically based on the available ports.
   - Starting the Acestream container and opening the web interface.

### Usage
1. **Choose your language**: Download either `SetupAcestream.bat` (English) or `SetupAcestream_es.bat` (Spanish)
2. **Run as Administrator**: Right-click the chosen script and select "Run as Administrator"
3. **Follow prompts**: The script will guide you through the setup process

> **Note:** The script ensures the latest Acestream Docker image is used and that the container management is handled
> efficiently.

## Building the Image

This project uses the **ubuntu:22.04** base image. You must clone the project first. Then, to build the image, use:

```bash
docker build --no-cache -t docker-acestream .
```

## Running the Container

To start a container and run Acestream with dynamic port assignment:

```bash
docker run --name docker-acestream -d -p 6878:6878 -e INTERNAL_IP=127.0.0.1 --restart unless-stopped docker-acestream
```

The `SetupAcestream.bat` script handles the dynamic assignment of ports to prevent conflicts when running multiple
instances.

## Docker Compose

1. **Start the Container**: Use `docker-compose` to start the container:

   ```bash
   docker-compose up -d
    ```

2. **Update the Image**: To get the latest image version:

   ```bash
   docker-compose pull && docker-compose up -d
    ```

## Accessing the Web Interface

Access Acestream via the web interface. The `SetupAcestream.bat` script automatically opens the correct URL based on the
assigned port:

```plaintext
http://<INTERNAL_IP>:<PORT>/webui/player/
```

You can load Acestream links directly in the provided input field.

## Verifying Container Health

Check the health status of the Acestream container:

```bash
docker inspect --format='{{json .State.Health}}' docker-acestream
```

Alternatively, use the web interface:

```plaintext
http://<INTERNAL_IP>:<PORT>/webui/api/service?method=get_version
```

## Customization

### Dynamic Port Assignment

The project includes dynamic port assignment for both HTTP and HTTPS ports to prevent conflicts when running multiple
instances. This is handled in the `SetupAcestream.bat` script.

### Web Interface Configuration

The `player.html` file is dynamically updated with the correct IP address and port during the container startup process.
This ensures that the web interface points to the correct Acestream engine instance.

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| INTERNAL_IP | IP address used by the player and engine to bind as the advertised endpoint. | 127.0.0.1 |
| HTTP_PORT | Port exposed for HTTP traffic inside the container. | 6878 |
| HTTPS_PORT | Port exposed for HTTPS traffic inside the container. | 6879 |

## Key Features

- One-click Windows setup scripts with automatic Docker image download and dynamic port assignment.
- Pre-configured `acestream.conf` with production-ready limits for concurrent peers and robust caching.
- Hardened startup script (`entrypoint.sh`) that validates environment variables and outputs detailed diagnostics.
- Automatic patch of `player.html` so the web UI always points to the correct IP and port.
- Multi-instance support: launch several containers simultaneously without port clashes.
- Offline builds thanks to the bundled `resources/acestream.tar.gz` archive (no external downloads required).

## Troubleshooting & Tips

- Ensure the ports selected by the Windows script are **open in your firewall**.
- For Linux/macOS usage set `INTERNAL_IP`, `HTTP_PORT`, and `HTTPS_PORT` accordingly when running `docker run` or `docker-compose`.
- View real-time logs with `docker logs -f <container_name>` to diagnose engine issues.
- The engine writes additional debug information when the `--log-debug` flag is enabled in `acestream.conf`.

## Legal Notice

This repository only distributes automation scripts. The Acestream binary blob is provided for **personal, educational or research purposes**.
You are solely responsible for ensuring that your usage complies with all applicable laws and regulations.

## Contributions

We welcome contributions. Fork, make changes, and submit a pull request for review.

## License

This project is under the MIT License. See [LICENSE](LICENSE) for more details.
