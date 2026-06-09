#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

#################
# NGINX SETTING #
#################
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
bashio::log.green "connection_mode is $connection_mode"

if [ ! -f "$CONFIG_LOCATION" ]; then
    # First boot: config.ini doesn't exist yet.
    # /defaults/config.ini (which already has http_root = /lazylibrarian) will be
    # copied by init-lazylibrarian-config before svc-lazylibrarian starts.
    bashio::log.info "config.ini not found — will be created from defaults with http_root pre-set"
    exit 0
fi

# Subsequent boots: patch config.ini if http_root needs updating.
case "$connection_mode" in
    ingress)
        bashio::log.green "Ingress enabled — ensuring http_root = /lazylibrarian"
        bashio::log.yellow "WARNING: Ensure port 5299 is not exposed externally to avoid a security risk!"
        if grep -q "^http_root" "$CONFIG_LOCATION"; then
            sed -i 's|^http_root =.*|http_root = /lazylibrarian|' "$CONFIG_LOCATION"
        else
            sed -i '/^\[General\]/a http_root = /lazylibrarian' "$CONFIG_LOCATION"
        fi
        ;;
    noingress)
        bashio::log.green "Ingress disabled — clearing http_root for direct access"
        if grep -q "^http_root" "$CONFIG_LOCATION"; then
            sed -i 's|^http_root =.*|http_root =|' "$CONFIG_LOCATION"
        fi
        ;;
esac
