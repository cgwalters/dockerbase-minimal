#!/bin/bash
target=${1:-centos}
case $target in
    centos)
	releasever=7 ;;
    fedora)
	releasever=24 ;;
    *) echo "unknown target $target"; exit 1
esac

sed -e "s,\@target\@,${target}:${releasever},g" < buildcontainer/Dockerfile.in > buildcontainer/Dockerfile
buildimgname=cgwalters/${target}-builder:${releasever}
(cd buildcontainer && docker build -t ${buildimgname} .)

docker run --privileged --net=host --rm -v $(pwd):/srv --workdir /srv ${buildimgname} /srv/build-via-yum.sh "${target}"
