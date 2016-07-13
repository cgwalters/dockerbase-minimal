#!/bin/bash
set -eu
# See: https://bugzilla.redhat.com/show_bug.cgi?id=1051816
KEEPLANG=en_US
for dir in locale i18n; do 
    find /usr/share/${dir} -mindepth  1 -maxdepth 1 -type d -not \( -name "${KEEPLANG}" -o -name POSIX \) -exec rm -rf {} +
done
localedef --list-archive | grep -a -v ^"${KEEPLANG}" | xargs localedef --delete-from-archive
mv -f /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.tmpl
build-locale-archive
