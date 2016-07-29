#!/bin/bash
target=${1:-centos}
releasever=${2:-}
if test -n ${releasever}; then
    case $target in
	centos)
	    releasever=7 ;;
	fedora)
	    releasever=24 ;;
	*) echo "unknown target $target"; exit 1
    esac
fi

sed -e "s,\@target\@,${target}:${releasever},g" < buildcontainer/Dockerfile.in > buildcontainer/Dockerfile
buildimgname=cgwalters/${target}-builder:${releasever}
(cd buildcontainer && docker build -t ${buildimgname} .)

docker run --privileged --net=host --rm -v $(pwd):/srv --workdir /srv ${buildimgname} /srv/build-via-yum --target "${target}" --releasever=${releasever}
