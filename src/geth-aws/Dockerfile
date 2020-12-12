FROM infrablocks/alpine-aws-s3-config:0.21.0

ENV GETH_VERSION 1.9.25

RUN apk \
    --verbose \
    --no-cache \
    add \
        su-exec

RUN addgroup -S geth && \
    adduser -S -G geth geth

RUN mkdir -p /opt/geth \
    && chown -R geth:geth \
        /opt/geth
