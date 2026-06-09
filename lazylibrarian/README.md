# Home assistant add-on: LazyLibrarian

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FArgusLi%2Fhaos-app-lazylibrarian)

## Addon informations

![Version](https://img.shields.io/badge/dynamic/yaml?label=Version&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2FArgusLi%2Fhaos-app-lazylibrarian%2Fmaster%2Flazylibrarian%2Fconfig.yaml)
![Ingress](https://img.shields.io/badge/dynamic/yaml?label=Ingress&query=%24.ingress&url=https%3A%2F%2Fraw.githubusercontent.com%2FArgusLi%2Fhaos-app-lazylibrarian%2Fmaster%2Flazylibrarian%2Fconfig.yaml)
![Arch](https://img.shields.io/badge/dynamic/yaml?color=success&label=Arch&query=%24.arch&url=https%3A%2F%2Fraw.githubusercontent.com%2FArgusLi%2Fhaos-app-lazylibrarian%2Fmaster%2Flazylibrarian%2Fconfig.yaml)

## About

---

[LazyLibrarian](https://lazylibrarian.gitlab.io/) is a program to follow authors and grab metadata for all your digital reading needs. It supports eBooks, audiobooks, magazines, and comics via integration with downloaders like SABnzbd, NZBGet, qBittorrent, Transmission, and others.

This addon is based on the docker image https://github.com/linuxserver/docker-lazylibrarian

## Installation

---

The installation of this add-on is pretty straightforward and not different in comparison to installing any other add-on.

1. Add this add-ons repository to your home assistant instance (in supervisor addons store at top right, or click the button above if you have configured my HA)
1. Install this add-on.
1. Click the `Save` button to store your configuration.
1. Set the add-on options to your preferences.
1. Start the add-on.
1. Check the logs of the add-on to see if everything went well.
1. Open the webUI and adapt the software options.

## Configuration

WebUI can be found at `http://homeassistant:5299/lazylibrarian` or through the sidebar using Ingress.
Configurations can be done through the app webUI, except for the following options.

### Options

| Option            | Type | Default   | Description                                                                 |
| ----------------- | ---- | --------- | --------------------------------------------------------------------------- |
| `PUID`            | int  | `0`       | User ID for file permissions                                                |
| `PGID`            | int  | `0`       | Group ID for file permissions                                               |
| `TZ`              | str  |           | Timezone (e.g., `America/Vancouver`)                                        |
| `connection_mode` | list | `ingress` | `ingress` — serve through HA sidebar; `noingress` — direct port access only |

### Connection Modes

- `ingress` — Default. LazyLibrarian is served through the HA sidebar via Ingress. `http_root` is automatically set to `/lazylibrarian`. No port mapping required.
- `noingress` — Disables Ingress. Access directly on port 5299. Ensure the port is mapped in add-on configuration.

### Example Configuration

```yaml
PUID: 0
PGID: 0
TZ: "America/Vancouver"
connection_mode: "ingress"
```

### Storage paths

Set your book and download folders inside the LazyLibrarian webUI to paths under `/share/`, for example:

| Purpose        | Suggested path      |
| -------------- | ------------------- |
| Books / eBooks | `/share/books`      |
| Downloads      | `/share/downloads`  |
| Audiobooks     | `/share/audiobooks` |

These paths are persistent across restarts and shared with other HA add-ons (e.g. SABnzbd, qBittorrent).

The add-on configuration and database are stored in the add-on config volume (`/config` inside the container).

## Support

Create an issue on GitHub: https://github.com/ArgusLi/haos-app-lazylibrarian/issues

[repository]: https://github.com/ArgusLi/haos-app-lazylibrarian
