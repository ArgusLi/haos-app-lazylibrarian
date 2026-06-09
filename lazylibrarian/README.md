# LazyLibrarian Home Assistant Add-on

LazyLibrarian is a program to follow authors and grab metadata for all your digital reading needs.
It supports eBooks, audiobooks, magazines, and comics via integration with downloaders like SABnzbd,
NZBGet, qBittorrent, Transmission, and others.

## Installation

1. Go to **Settings → Add-ons → Add-on Store → ⋮ → Repositories**.
2. Add the repository URL: `https://github.com/ArgusLi/haos-app-lazylibrarian`
3. Find **LazyLibrarian** in the store and click **Install**.
4. Start the add-on and click **Open Web UI**.

On first start LazyLibrarian creates its configuration. The Web UI is accessible via HA Ingress or
directly on port 5299 if you map it.

## Configuration

| Option | Default | Description |
|---|---|---|
| `PUID` | `0` | User ID the process runs as |
| `PGID` | `0` | Group ID the process runs as |
| `TZ` | *(empty)* | Timezone, e.g. `America/New_York` |
| `connection_mode` | `ingress` | `ingress` — serve through HA panel; `noingress` — direct port only |

## Volume paths

| Container path | Purpose |
|---|---|
| `/config` | LazyLibrarian configuration and database (backed by add-on config storage) |
| `/share` | Shared storage for books and downloads |

In the LazyLibrarian UI set your book and download folders under `/share/`, for example:

- Books: `/share/books`
- Downloads: `/share/downloads`

These paths persist across restarts and are shared with other HA add-ons.

## Ingress vs direct access

With `connection_mode: ingress` (default) the add-on is available directly from the HA sidebar
and no port mapping is required. LazyLibrarian's `http_root` is automatically set to `/lazylibrarian`.

With `connection_mode: noingress` the `http_root` is cleared and the app is reachable only on
port 5299. Make sure the port is mapped in the add-on configuration.

## Support

- [LazyLibrarian documentation](https://lazylibrarian.gitlab.io/)
- [Add-on issues](https://github.com/ArgusLi/haos-app-lazylibrarian/issues)
