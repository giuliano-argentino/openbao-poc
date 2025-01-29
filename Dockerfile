FROM golang:1.23.5 AS builder

# Install dependencies for building UI assets
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    git \
    make \
    curl

# Install yarn
RUN npm install -g yarn

# Clone OpenBao repository
RUN git clone https://github.com/openbao/openbao.git /openbao
WORKDIR /openbao

# Build UI assets
RUN make static-dist

# Build OpenBao with UI
RUN make dev-ui

# Create final image
FROM alpine:latest
COPY --from=builder /openbao/bin/bao /usr/local/bin/bao
RUN mkdir -p /vault/config /vault/data
EXPOSE 8200
ENTRYPOINT ["bao", "server", "-config=/vault/config/config.hcl"]