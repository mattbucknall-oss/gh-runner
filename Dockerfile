# Use Ubuntu base image
FROM ubuntu:focal

# Suppress interaction during setup
ENV DEBIAN_FRONTEND=noninteractive

# Copy entrypoint script into container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    gcc \
    g++ \
    git \
    jq \
    ninja-build \
    pbzip2 \
    pigz \
    sudo \
    tar \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add non-root user and give it ownership of runner directory
RUN useradd -m ghr

# Add ghr to the sudoers file
RUN echo "ghr ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /home/ghr/

# Download and extract GH runner, install dependencies
RUN curl -o actions-runner-linux.tar.gz -L \
    https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz \
    && tar -xzf actions-runner-linux.tar.gz \
    && rm actions-runner-linux.tar.gz \
    && ./bin/installdependencies.sh

# Assign ownership of everything to ghr user
RUN chown ghr:ghr -R .

# Switch to non-root user
USER ghr
