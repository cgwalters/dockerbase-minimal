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
trap cleanup EXIT

yum -y --setopt=cachedir=$(pwd)/cache --setopt=tsflags=nodocs --setopt=override_install_langs=en \
     --setopt=reposdir=$(pwd) --releasever=7 --installroot=${tempdir}/root install \
     micro-yuminst centos-release
root=${tempdir}/root
install -m 0755 locales-and-docs.sh ${root}/tmp
chroot ${root} /tmp/locales-and-docs.sh
(cd ${root} &&
 rm -rf etc/machine-id var/cache/* run/* tmp/*)
rm -f centosmin.tar
tar -f centosmin.tar -C ${root} -c .
