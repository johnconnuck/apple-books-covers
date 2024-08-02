#!/usr/bin/env bash

set -eEu -o pipefail
shopt -s inherit_errexit
IFS=$'\n\t'
PS4='+\t '

error_handler() { echo "Error: Line ${1} exited with status ${2}"; }
trap 'error_handler ${LINENO} $?' ERR


set -x

CALIBRE_BIN_PATH="$PWD/calibre"
PLUGIN=$(find . -type f -name 'Apple.Books.*.zip')

CALIBRE_USER_PATH="$(mktemp -d -t calibre.user.XXXXXX)"
mkdir -p "${CALIBRE_USER_PATH}/config" "${CALIBRE_USER_PATH}/tmp"
export CALIBRE_CONFIG_DIRECTORY="${CALIBRE_USER_PATH}/config"
export CALIBRE_TEMP_DIR="${CALIBRE_USER_PATH}/tmp"

# shellcheck disable=SC2064
trap "rm -rf '${CALIBRE_USER_PATH:-''}'" EXIT

"${CALIBRE_BIN_PATH}/calibre-customize" -a "${PLUGIN}"
"${CALIBRE_BIN_PATH}/calibre-customize" --enable-plugin "$(basename "${PLUGIN%.zip}")"

PYTHONDONTWRITEBYTECODE="true" "${CALIBRE_BIN_PATH}/calibre-debug" tests/test_applebooks.py
