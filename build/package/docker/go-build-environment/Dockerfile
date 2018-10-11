FROM golang:1.11-alpine3.8 AS BuildResumeApp
LABEL MAINTAINER="james@byteporter.com"

# ENV CGO_ENABLED=0

RUN set -x \
    && apk add --no-cache --virtual .build-deps git make
