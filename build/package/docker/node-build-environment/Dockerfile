FROM library/node:8-alpine

RUN set -x \
    && apk add --no-cache --virtual .build-deps make m4 findutils \
    && npm install -g less uglifycss

WORKDIR /go/src/github.com/byteporter/resume/
ENTRYPOINT [ "/bin/sh", "-c", "\"$@\"", "_" ]
