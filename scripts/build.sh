#!/usr/bin/env bash

set -eEu -o pipefail
shopt -s inherit_errexit
IFS=$'\n\t'
PS4='+\t '

error_handler() { echo "Error: Line ${1} exited with status ${2}"; }
trap 'error_handler ${LINENO} $?' ERR


VERSION=$(git describe --tags --dirty)
ZIP="Apple.Books.covers-${VERSION}.zip"

curl -OL 'https://salsa.debian.org/iso-codes-team/iso-codes/-/raw/main/data/iso_3166-1.json'
zip "${ZIP}" -- *.py *.md *.json plugin-import-name-*.txt
echo Generated "${ZIP}"
