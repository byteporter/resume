FROM debian:buster
LABEL MAINTAINER="james@byteporter.com"

ENV LANG='C.UTF-8'

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    poppler-utils \
    fonts-open-sans \
    fontconfig \
    make \
    m4 \
    haskell-platform \
    texlive-luatex \
    context \
    context-modules \
    pandoc \
    && apt-get autoclean \
    && apt-get clean

RUN set -x \
    && OSFONTDIR=/usr/share/fonts// mtxrun --script fonts --reload --force
    
ENTRYPOINT [ "/bin/sh", "-c", "\"$@\"", "_" ]
