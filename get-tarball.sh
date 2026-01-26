#!/usr/bin/env bash

set -e

VERSION=6
while test $# -gt 0; do
	case $1 in
		-t)
			TAG=$2;
			shift 2
			;;
		-v)
			VERSION=$2
			shift 2
			;;
		*)
			exit 1
			;;
	esac
done

if [ -z "$TAG" ]; then
	echo "No tag provided!"
	exit 1
fi

docker run --rm -u $(id -u):$(id -g) -v "$PWD":"$PWD" -w "$PWD" ghcr.io/jjl772/rtems-$VERSION-toolchains:$TAG bash -c "tar -C /opt/rtems/$VERSION -cvf - . | xz -3 > $PWD/rtems-$VERSION-$TAG.tar.xz"
