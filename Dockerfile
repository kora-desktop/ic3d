FROM rust:1.92

RUN apt-get update && apt-get install -y \
    cmake \
    libclang-dev \
    mesa-vulkan-drivers \
    vulkan-tools \
    && rm -rf /var/lib/apt/lists/*

# Taskfile support
RUN curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | bash
RUN apt-get install -y task

RUN rustup component add clippy rustfmt

# Debian 13's Vulkan loader (1.4.309) can crash when tests create wgpu devices on
# several threads at once; the loader fixed that race in 1.4.350. Take Debian's 1.4.363.
RUN curl -fsSLo /tmp/libvulkan1.deb https://snapshot.debian.org/archive/debian/20261002T142810Z/pool/main/v/vulkan-loader/libvulkan1_1.4.363.0-1_amd64.deb \
    && echo "ecd870e27cc1eb7b91130b01e629595e8f35bf58c7815c2a8b7beb27b9804899  /tmp/libvulkan1.deb" | sha256sum -c - \
    && dpkg -i /tmp/libvulkan1.deb \
    && rm /tmp/libvulkan1.deb
