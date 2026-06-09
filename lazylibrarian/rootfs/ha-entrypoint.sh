#!/usr/bin/env bash
# shellcheck shell=bash
#
# Home Assistant add-on entrypoint.
#
# The LinuxServer base image decides which user the app runs as during its
# `init-adduser` step, which reads PUID/PGID (and TZ) from the *environment* —
# and that step runs early, before /etc/cont-init.d scripts. Home Assistant,
# however, exposes the add-on's configured options in /data/options.json, not
# as environment variables. So we read them here (as PID 1, before s6-overlay's
# /init starts) and export them, then hand off to the normal init. Without this,
# PUID/PGID are ignored and the app runs as the image default (abc / 911).

if [ -f /data/options.json ]; then
    PUID="$(jq -r '.PUID // empty' /data/options.json)"
    PGID="$(jq -r '.PGID // empty' /data/options.json)"
    TZ="$(jq -r '.TZ // empty' /data/options.json)"
    [ -n "$PUID" ] && export PUID
    [ -n "$PGID" ] && export PGID
    [ -n "$TZ" ] && export TZ
fi

exec /init "$@"
