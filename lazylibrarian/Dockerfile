ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SERVICES_GRACETIME=0

ARG BASHIO_VERSION=0.16.2
RUN apt-get update \
 && apt-get install -y --no-install-recommends nginx curl jq \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /tmp/bashio \
 && curl -L -s "https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz" \
      | tar -xzf - --strip 1 -C /tmp/bashio \
 && mv /tmp/bashio/lib /usr/lib/bashio \
 && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
 && if [ ! -e /usr/bin/with-contenv ] && [ -e /command/with-contenv ]; then \
       ln -s /command/with-contenv /usr/bin/with-contenv; fi \
 && rm -rf /tmp/bashio

COPY rootfs/ /
RUN find /etc/cont-init.d /etc/services.d -type f \
      \( -name "*.sh" -o -name "run" -o -name "finish" \) -exec chmod +x {} \; \
 && chmod +x /ha-entrypoint.sh

# Inject PUID/PGID/TZ from the add-on options before s6-overlay's /init runs,
# so the LinuxServer init-adduser step actually honors them.
ENTRYPOINT ["/ha-entrypoint.sh"]

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
ENV BUILD_VERSION="${BUILD_VERSION}"
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="ArgusLi (https://github.com/ArgusLi)" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="ArgusLi (https://github.com/ArgusLi)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/ArgusLi" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
