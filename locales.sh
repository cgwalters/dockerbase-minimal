#!/bin/bash
set -eu
# See also the bit in postprocess.sh
KEEPLANG=en_US
localedef --list-archive | grep -a -v ^"${KEEPLANG}" | while read lang; do localedef --delete-from-archive ${lang}; done
mv -f /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.tmpl
build-locale-archive
