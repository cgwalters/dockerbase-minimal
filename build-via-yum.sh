#!/bin/bash
set -xeuo pipefail

target=${1:-centos}
case $target in
    centos)
	releasever=7
        cmd="yum"
	;;
    fedora)
	releasever=24
        cmd="dnf --setopt=install_weak_deps=False"
	;;
    *) echo "unknown target $target"; exit 1
esac

tempdir=$(mktemp -d -p /var/tmp ${target}min.XXXXXX)
touch ${tempdir}/.tmpstamp
function cleanup () {
    if test -n "${BUILD_SKIP_CLEANUP:-}"; then
	echo "Skipping cleanup of ${tempdir}"
    else if test -f ${tempdir}/.tmpstamp; then
	rm "${tempdir}" -rf
    fi
    fi
}

${cmd} -y --setopt=cachedir=$(pwd)/cache --setopt=keepcache=1 --setopt=tsflags=nodocs --setopt=override_install_langs=en \
     --setopt=reposdir=$(pwd)/repos-${target} --releasever=${releasever} --installroot=${tempdir}/root install \
     micro-yuminst ${target}-release

root=${tempdir}/root
# We need to run this in target context in the general case
install -m 0755 locales.sh ${root}/tmp
chroot ${root} /tmp/locales.sh
./postprocess.sh ${root}

rm -f ${target}min.tar.gz
tar --numeric-owner -zf ${target}min.tar.gz -C ${root} -c .
