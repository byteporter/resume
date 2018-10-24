FROM library/node:8-alpine

RUN set -x \
    && apk add --no-cache --virtual .build-deps make m4 findutils \
    && npm install -g less uglifycss

ENTRYPOINT [ "/bin/sh", "-c", "\"$@\"", "_" ]
