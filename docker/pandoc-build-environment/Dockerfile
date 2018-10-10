FROM debian:buster AS BuildResumeDocuments
LABEL MAINTAINER="james@byteporter.com"

ENV LANG='C.UTF-8'

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    poppler-utils \
    fonts-open-sans \
    fontconfig \
    make \
    haskell-platform \
    context \
    context-modules \
    pandoc \
    && apt-get autoclean \
    && apt-get clean

RUN set -x \
    OSFONTDIR="/usr/share/fonts//" mtxrun --script fonts --reload --force

# WORKDIR /build

# COPY resume.md /build
# COPY pdftemplate.tex /build
# COPY Makefile /build

# RUN set -x \
#     && make pdf \
#     && make docx \
#     && make rtf