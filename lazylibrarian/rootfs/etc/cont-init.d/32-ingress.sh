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

connection_mode="$(bashio::config "connection_mode")"
bashio::log.green "connection_mode is $connection_mode"

if bashio::config.equals "connection_mode" "ingress"; then
    bashio::log.green "Ingress enabled — http_root will be set via --http_root startup arg"
    bashio::log.yellow "WARNING: Ensure port 5299 is not exposed externally to avoid a security risk!"
else
    bashio::log.green "Ingress disabled — direct port access only"
fi
