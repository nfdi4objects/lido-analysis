#!/usr/bin/bash
set -e

apt-get install jq wget pigz xsltproc raptor2-utils

# metha
set $(curl -s https://api.github.com/repos/miku/metha/releases/latest \
    | jq -r '.assets[]|select(.name|match(".deb$"))|[.browser_download_url,.name]|@tsv')
wget -O $2 $1
dpkg -i $2
