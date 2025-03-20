ARG BUILD_FROM

FROM $BUILD_FROM

# package versions
ARG ARGTABLE_VER="2.13"

# environment settings
ARG TZ="Etc/UTC"

ENV HOME="/config"

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

COPY bin/tvheadend-4.3-2375~g653bd0400-aarch64.gz.tar /tmp/

RUN \
    cd / && \
    tar xf /tmp/tvheadend-4.3-2375~g653bd0400-aarch64.gz.tar && \
    rm -f /tmp/tvheadend-4.3-2375~g653bd0400-aarch64.gz.tar

ARG PICONS_RELEASE="2025-03-04--22-19-23"

COPY requirements.txt /tmp/

RUN \
    apk update \
    && apk add --no-cache --virtual .build-deps \
    musl-dev \
    gcc \
    g++ \
    libxml2-dev \
    libxslt-dev \
    python3-dev \
    && apk add --no-cache \
    bsd-compat-headers \
    ffmpeg4 \
    ffmpeg \
    ffmpeg4-libavcodec \
    ffmpeg4-libavdevice \
    ffmpeg4-libavfilter \
    ffmpeg4-libavformat \
    ffmpeg4-libavutil \
    ffmpeg4-libpostproc \
    ffmpeg4-libswresample \
    ffmpeg4-libswscale \
    gnu-libiconv \
    libdvbcsa \
    libhdhomerun-libs \
    libva \
    libvpx \
    libxml2 \
    libxslt \
    opus \
    pcre2 \
    perl \
    perl-datetime-format-strptime \
    perl-json \
    perl-json-xs \
    py3-requests \
    python3 \
    uriparser \
    x264 \
    x265 \
    xmltv \
    zlib \
    py3-pip \
    libxslt \
    xmlstarlet \
    && pip3 install \
    --no-cache-dir \
    --prefer-binary \
    --break-system-packages \
    -r /tmp/requirements.txt \
    && apk del --no-cache --purge .build-deps

COPY --from=builder /tmp/tvheadend-build/usr/ /usr/

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN \
  mkdir -p /picons/tmp \
  mkdir /picons/snp \
  mkdir /picons/srp \
  && curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/picons/picons/releases/tags/"${PICONS_RELEASE}" > /picons/tmp/release.json \
  && jq -r '.assets[] | select(.name | test("^snp-full\\.220x132-190x102\\.light\\.on\\.transparent.*symlink\\.tar\\.xz$")) | .browser_download_url' /picons/tmp/release.json | xargs wget -O /picons/tmp/snp.tar.xz \
  && jq -r '.assets[] | select(.name | test("^srp-full\\.220x132-190x102\\.light\\.on\\.transparent.*symlink\\.tar\\.xz$")) | .browser_download_url' /picons/tmp/release.json | xargs wget -O /picons/tmp/srp.tar.xz \
  && tar xfJ /picons/tmp/snp.tar.xz -C /picons/snp --strip-components=1 \
  && tar xfJ /picons/tmp/srp.tar.xz -C /picons/srp --strip-components=1 \
  && rm -rf /picons/tmp

  # Install script.o2tv.server
RUN \
  apk add --no-cache --virtual .build-deps \
  zip \
  wget \
  && mkdir -p /usr/local/lib/ \
  && cd /usr/local/lib \
  && wget https://github.com/waladir/script.o2tv.server/archive/refs/heads/master.zip \
  && unzip master.zip \
  && rm master.zip \
  && cd script.o2tv.server-master \
  && cp config.txt.sample config.txt \
  && chmod +x server.py \
  && apk del --no-cache --purge .build-deps

  # Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Jaroslav Hykel" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="jaroslavhykel" \
    org.opencontainers.image.authors="Jaroslav Hykel" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/jaroslavhykel/ha_tvheadend" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
