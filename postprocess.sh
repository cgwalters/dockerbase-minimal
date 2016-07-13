#!/bin/bash
set -euo pipefail
root=$1
shift
test -n "${root:-}" && test ${root} != '/'
cd ${root}
# Strip documentation 
find usr/share/doc/ -type f |
  (while read line; do
    bn=$(basename ${line});
    if echo ${bn} | grep -Eiq '^(COPYING|LICENSE)'; then
      continue
    else
       rm $line
    fi;
   done)
rm usr/share/doc/{info,man} -rf
# Pruning random things
rm usr/lib/rpm/rpm.daily   # seriously?
rm usr/lib64/nss/unsupported-tools/ -rf  # unsupported

# Final pruning
rm -rf etc/machine-id var/cache/* run/* tmp/*
