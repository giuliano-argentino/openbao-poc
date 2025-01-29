# Builder Stage
FROM golang:1.23.5 AS builder

# Install dependencies for building UI assets
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    git \
    make \
    curl && \
    npm install -g yarn

# Clone OpenBao repository
RUN git clone https://github.com/openbao/openbao.git /openbao
WORKDIR /openbao

# Build UI assets
RUN make static-dist

# Build OpenBao with UI
RUN make dev-ui

# Clean up unnecessary files to reduce layer size
RUN rm -rf /openbao/.git /openbao/ui/node_modules

# Final Stage
FROM alpine:latest

# Create directories and set permissions
RUN mkdir -p /vault/config/ /vault/data && \
    adduser -D -u 1000 bao && \
    chown -R bao:bao /vault

# Copy OpenBao binary and UI assets from the builder stage
COPY --from=builder /openbao/bin/bao /usr/local/bin/bao

# Set non-root user
USER bao

# Set working directory
WORKDIR /vault

# Entrypoint
ENTRYPOINT ["bao", "server", "-config=/vault/config/config.hcl"]

# Labels
LABEL maintainer="Your Name <your.email@example.com>"
LABEL version="1.0"
LABEL description="OpenBao with UI"