#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

#################
# NGINX SETTING #
#################
declare ingress_interface
declare ingress_port
declare ingress_entry

ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf
sed -i "s|%%ingress_entry%%|${ingress_entry}|g" /etc/nginx/servers/ingress.conf

##################
# CONFIG SETTING #
##################

CONFIG_LOCATION=/config/config.ini
connection_mode="$(bashio::config "connection_mode")"

bashio::log.green "---------------------------"
bashio::log.green "connection_mode is $connection_mode"
bashio::log.green "---------------------------"

if [ ! -f "$CONFIG_LOCATION" ]; then
    # First boot: config.ini doesn't exist yet. Pre-create it with the correct
    # http_root so LazyLibrarian loads the right value into memory on first start
    # and preserves it when saving config on shutdown.
    bashio::log.info "config.ini not found — creating with ingress settings"
    case "$connection_mode" in
        ingress)
            cat > "$CONFIG_LOCATION" <<EOF
[General]
http_root = /lazylibrarian
http_host = 0.0.0.0
http_port = 5299
EOF
            ;;
        noingress)
            cat > "$CONFIG_LOCATION" <<EOF
[General]
http_root =
http_host = 0.0.0.0
http_port = 5299
EOF
            ;;
    esac
    chown "${PUID}:${PGID}" "$CONFIG_LOCATION"
else
    # Subsequent boots: patch the existing config in case connection_mode changed
    case "$connection_mode" in
        ingress)
            bashio::log.green "Ingress enabled — setting http_root to /lazylibrarian"
            bashio::log.yellow "WARNING: Ensure port 5299 is not exposed externally to avoid a security risk!"
            sed -i 's|^http_root =.*|http_root = /lazylibrarian|' "$CONFIG_LOCATION"
            sed -i 's|^http_host =.*|http_host = 0.0.0.0|' "$CONFIG_LOCATION"
            sed -i 's|^http_port =.*|http_port = 5299|' "$CONFIG_LOCATION"
            ;;
        noingress)
            bashio::log.green "Ingress disabled — clearing http_root for direct access"
            sed -i 's|^http_root =.*|http_root =|' "$CONFIG_LOCATION"
            ;;
    esac
fi
