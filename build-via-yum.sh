#!/bin/bash
set -xeuo pipefail
tempdir=$(mktemp -d -p /var/tmp centosmin.XXXXXX)
touch ${tempdir}/.tmpstamp
function cleanup () {
    if test -n "${BUILD_SKIP_CLEANUP:-}"; then
	echo "Skipping cleanup of ${tempdir}"
    else if test -f ${tempdir}/.tmpstamp; then
	rm "${tempdir}" -rf
    fi
    fi
}

yum -y --setopt=cachedir=$(pwd)/cache --setopt=keepcache=1 --setopt=tsflags=nodocs --setopt=override_install_langs=en \
     --setopt=reposdir=$(pwd) --releasever=7 --installroot=${tempdir}/root install \
     micro-yuminst centos-release

root=${tempdir}/root
# We need to run this in target context in the general case
install -m 0755 locales.sh ${root}/tmp
chroot ${root} /tmp/locales.sh
./postprocess.sh ${root}

rm -f centosmin.tar.gz
tar --numeric-owner -zf centosmin.tar.gz -C ${root} -c .
