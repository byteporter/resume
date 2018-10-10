FROM golang:1.11-alpine3.8 AS BuildResumeApp
LABEL MAINTAINER="james@byteporter.com"

# ENV CGO_ENABLED=0

RUN set -x \
    && apk add --no-cache --virtual .build-deps git make

# WORKDIR /go/src/github.com/byteporter/resume

# COPY resume.go /go/src/github.com/byteporter/resume
# COPY Makefile /go/src/github.com/byteporter/resume

# RUN set -x \
#     && go get ./...

# RUN set -x \
#     && make application