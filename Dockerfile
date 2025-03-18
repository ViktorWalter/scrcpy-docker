### builder
FROM alpine:edge AS builder

ARG SCRCPY_VER=3.1
ARG SERVER_HASH="958f0944a62f23b1f33a16e9eb14844c1a04b882ca175a738c16d23cb22b86c0"

RUN apk add --no-cache \
        curl \
        ffmpeg-dev \
        gcc \
        git \
        make \
        meson \
        musl-dev \
        openjdk8 \
        pkgconf \
        sdl2-dev \
        libusb \
        libusb-dev \
        cmake

RUN PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/bin
RUN curl -L -o scrcpy-server https://github.com/Genymobile/scrcpy/releases/download/v${SCRCPY_VER}/scrcpy-server-v${SCRCPY_VER}
RUN echo "$SERVER_HASH  /scrcpy-server" | sha256sum -c - && mkdir /usr/local/share/scrcpy && cp /scrcpy-server /usr/local/share/scrcpy/
RUN git clone https://github.com/Genymobile/scrcpy.git
RUN cd scrcpy && git checkout v${SCRCPY_VER} && meson x --buildtype release --strip -Db_lto=true -Dprebuilt_server=/scrcpy-server
RUN cd scrcpy/x && ninja && cp /scrcpy/x/app/scrcpy /usr/local/bin

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

LABEL maintainer="Pierre Gordon <pierregordon@protonmail.com>"

RUN apk add --no-cache \
        android-tools \
        ffmpeg \
        virtualgl
