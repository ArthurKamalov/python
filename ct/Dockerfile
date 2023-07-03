ARG DISTRO
ARG TOOLCHAIN_TYPE
ARG TOOLCHAIN_PLATFORM

FROM ubuntu:22.04 as base
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get install -y gcc g++ gperf bison flex texinfo help2man make libncurses5-dev \
    python3-dev python3-distutils autoconf automake libtool libtool-bin gawk wget bzip2 xz-utils unzip \
    patch libstdc++6 rsync git meson ninja-build curl gnupg2

ARG CTNG_UID=1000
ARG CTNG_GID=1000
RUN groupadd -g $CTNG_GID ctng
RUN useradd -d /home/ctng -m -g $CTNG_GID -u $CTNG_UID -s /bin/bash ctng
RUN chown -R ctng /home/ctng

FROM base as ctosstools_ng_build

ARG CROSSTOOLS_VERSION=1.25.0
RUN wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2
RUN wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2.sig

ADD crosstools_ng_public_key.gpg  public_key.gpg
RUN gpg2 --import public_key.gpg

RUN gpg2 --verify crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2.sig

RUN tar xf crosstool-ng-${CROSSTOOLS_VERSION}.tar.bz2

WORKDIR crosstool-ng-${CROSSTOOLS_VERSION}

RUN ./configure --prefix=/usr/local
RUN make -j "$(nproc)"
RUN make install