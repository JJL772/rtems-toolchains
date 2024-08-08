#!/usr/bin/env bash

set -e

while test $# -gt 0; do
	case $1 in
		-t)
			TAG=$2;
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

docker run --rm -u $(id -u):$(id -g) -v "$PWD":"$PWD" -w "$PWD" ghcr.io/jjl772/rtems-6:$TAG tar -C /usr/local -czvf rtems-6-$TAG.tar.gz .
