ARG FOR_GETH_VERSION="1.9.25"

FROM golang:1.15-alpine as builder

ARG FOR_GETH_VERSION
ENV GETH_VERSION="$FOR_GETH_VERSION"

RUN apk \
    --verbose \
    --no-cache \
    add \
        curl \
        gcc \
        git \
        linux-headers \
        make \
        musl-dev \
        tar

RUN cd /tmp \
    && curl \
        -L "https://github.com/ethereum/go-ethereum/archive/v${GETH_VERSION}.tar.gz" \
        -o "go-ethereum-${GETH_VERSION}.tar.gz" \
    && tar -xvf "go-ethereum-${GETH_VERSION}.tar.gz" \
    && cd "go-ethereum-${GETH_VERSION}" \
    && make geth

FROM infrablocks/alpine-aws-s3-config:0.21.0

ARG FOR_GETH_VERSION
ENV GETH_VERSION="${FOR_GETH_VERSION}"

RUN apk \
    --verbose \
    --no-cache \
    add \
        su-exec \
        gnupg

RUN addgroup -S geth && \
    adduser -S -G geth geth

RUN mkdir -p /opt/geth/bin

COPY --from=builder "/tmp/go-ethereum-${GETH_VERSION}/build/bin/geth" /opt/geth/bin

RUN chown -R geth:geth /opt/geth
