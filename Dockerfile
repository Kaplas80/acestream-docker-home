# Use the official Ubuntu 22.04 LTS (Jammy Jellyfish) base image
FROM ubuntu:22.04

# Define environment variables for encoding and app configuration
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV ACESTREAM_VERSION="acestream_3.2.3_ubuntu_22.04_x86_64_py3.10.tar.gz"
ENV INTERNAL_IP="127.0.0.1"
ENV HTTP_PORT="6878"
ENV HTTPS_PORT="6879"

# Install all system and Python dependencies in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Basic tools
    wget procps dos2unix \
    # Python environment
    python3 libpython3.10 python3-pip python3-setuptools python3-wheel \
    python3-greenlet python3-gevent python3-psutil python3-simplejson \
    # Build tools for Python modules
    build-essential python3-dev libsqlite3-dev libxml2-dev libxslt1-dev \
 && pip install --no-cache-dir \
    # Python modules required by Acestream
    apsw lxml PyNaCl requests pycryptodome isodate \
 && rm -rf /var/lib/apt/lists/*

# Copy the entrypoint script, fix line endings, and grant execute permissions
COPY config/entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

# Copy and extract Acestream from the local archive
COPY resources/acestream.tar.gz /tmp/acestream.tar.gz
RUN mkdir -p /opt/acestream && \
    tar --extract --gzip --directory /opt/acestream --file /tmp/acestream.tar.gz && \
    rm /tmp/acestream.tar.gz

# Overwrite the default web player with the custom version
COPY web/player.html /opt/acestream/data/webui/html/player.html

# Copy the Acestream configuration file
COPY config/acestream.conf /opt/acestream/acestream.conf

# Expose the default Acestream port
EXPOSE 6878

# Entrypoint for the container
ENTRYPOINT ["/entrypoint.sh"]
