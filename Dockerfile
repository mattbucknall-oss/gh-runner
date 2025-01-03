# Use Ubuntu base image
FROM ubuntu:oracular

# Suppress interaction during setup
ENV DEBIAN_FRONTEND=noninteractive

# Copy entrypoint script into container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-utils \
    autoconf \
    automake \
    autotools-dev \
    bash-completion \
    bc \
    bison \
    build-essential \
    ca-certificates \
    curl \
    debhelper \
    doxygen \
    flex \
    gawk \
    g++ \
    gdb \
    git \
    git-lfs \
    gperf \
    graphviz \
    jq \
    libexpat-dev \
    libfdt-dev \
    libglib2.0-dev \
    libgmp-dev \
    libhidapi-dev \
    libmpc-dev \
    libmpfr-dev \
    libpixman-1-dev \
    libslirp-dev \
    libssl-dev \
    libusb-1.0-0-dev \
    libtool \
    locales \
    m4 \
    ninja-build \
    pkg-config \
    patchutils \
    pbzip2 \
    pigz \
    python3 \
    python3-pip \
    ssh \
    sudo \
    telnet \
    texinfo \
    wget \
    xz-utils \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add non-root user and give it ownership of runner directory
RUN useradd -m ghr

# Add ghr to the sudoers file and allow PATH environment variable to be passed
RUN echo "ghr ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "Defaults env_keep += \"PATH\"" >> /etc/sudoers

# Set working directory
WORKDIR /home/ghr/

# Download and extract GH runner, install dependencies
RUN curl -o actions-runner-linux.tar.gz -L \
    https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz \
    && tar -xf actions-runner-linux.tar.gz \
    && rm actions-runner-linux.tar.gz \
    && ./bin/installdependencies.sh

# Download and extract riscv32-unknown-elf toolchain
RUN curl -o riscv32-unknown-elf.tar.bz2 -L \
    https://github.com/mattbucknall-oss/rv32im-gnu-toolchain/releases/download/release-20241228002103/riscv32-unknown-elf-20241228002103.tar.bz2 \
    && tar -xf riscv32-unknown-elf.tar.bz2 \
    && rm riscv32-unknown-elf.tar.bz2

# Assign ownership of everything to ghr user
RUN chown ghr:ghr -R .

# Switch to non-root user
USER ghr

# Add risc32-unknown-elf toolchain to path
ENV PATH="/home/ghr/rv32im-gnu-toolchain/bin:${PATH}"
