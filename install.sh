#!/usr/bin/bash
set -e

# general tools
apt-get install jq wget pigz

# XML processing
apt-get install xsltproc libxml2-utils xmlstarlet

# RDF processing
apt-get install raptor2-utils

# metha OAI-PMH client
set $(curl -s https://api.github.com/repos/miku/metha/releases/latest \
    | jq -r '.assets[]|select(.name|match(".deb$"))|[.browser_download_url,.name]|@tsv')
wget -O $2 $1
dpkg -i $2
