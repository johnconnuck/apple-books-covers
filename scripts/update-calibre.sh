#!/usr/bin/env bash

set -eEu -o pipefail
shopt -s inherit_errexit
IFS=$'\n\t'
PS4='+\t '

error_handler() { echo "Error: Line ${1} exited with status ${2}"; }
trap 'error_handler ${LINENO} $?' ERR


set -x

RELEASE_URL=https://api.github.com/repos/kovidgoyal/calibre/releases/latest
CALIBRE_BIN_PATH="$PWD/calibre"

CALIBRE_TAR_PATH="$(mktemp -t calibre-XXXXXX.txz)"

# shellcheck disable=SC2064
trap "rm -rf '${CALIBRE_TAR_PATH:-''}'" EXIT

DOWNLOAD_URL="$(curl -sS "$RELEASE_URL" | jq -r '.assets[] | select(.name | endswith("-x86_64.txz")).browser_download_url')"
curl -sSL -o "$CALIBRE_TAR_PATH" "$DOWNLOAD_URL"
rm -rf "$CALIBRE_BIN_PATH"
mkdir "$CALIBRE_BIN_PATH"
tar -x -C "$CALIBRE_BIN_PATH" -f "$CALIBRE_TAR_PATH"
