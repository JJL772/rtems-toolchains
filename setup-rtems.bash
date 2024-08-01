#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

CLEAN_AFTER_INSTALL=0
while test $# -gt 0; do
	case $1 in
		-a)
			ARCH="$2"
			shift 2
			;;
		-p)
			PREFIX="$2"
			shift 2
			;;
		-c)
			CLEAN_AFTER_INSTALL=1
			shift
			;;
		*)
			echo "Unknown arg $1"
			exit 1
			;;
	esac
done

[ -z "$PREFIX" ] && echo "Missing -p argument for prefix" && exit 1
[ -z "$ARCH" ] && echo "Missing -a argument for arch" && exit 1

echo "Using PREFIX=$PREFIX"
export PATH="$PREFIX:$PATH"

case $ARCH in
	powerpc)
		BSPS="powerpc/mvme3100,powerpc/beatnik"
		;;
	m68k)
		BSPS="m68k/uC5282"
		;;
	i386)
		BSPS="i386/pc586"
		;;
	*)
		echo "Unsupported arch"
		exit 1
		;;
esac
echo "Targeting BSPS: $BSPS"

############# RTEMS kernel ############# 

if [ ! -d rtems ]; then
	git clone https://gitlab.rtems.org/rtems/rtos/rtems.git --recursive --depth=1
	cd rtems
else
	cd rtems
	git clean -ffdx .
fi

./waf bspdefaults --rtems-bsps="$BSPS" > config.ini

# POSIX API required for RTEMS 5+ in EPICS base
sed -i 's/RTEMS_POSIX_API = False/RTEMS_POSIX_API = True/g' config.ini

# Enable SMP for compatible BSPs
sed -i 's/RTEMS_SMP = False/RTEMS_SMP = True/g' config.ini

./waf configure --rtems-bsps="$BSPS" --prefix="$PREFIX"

./waf build install

cd ..
if [ $CLEAN_AFTER_INSTALL -eq 1 ]; then
	rm -rf rtems
fi

############# RTEMS libbsd ############# 

if [ ! -d rtems-libbsd ]; then
	# NOTE: Using shallow clone here because the .git folder in rtems-libbsd is 3.2G(!!!)
	git clone https://gitlab.rtems.org/rtems/pkg/rtems-libbsd.git --recursive --depth=1
	cd rtems-libbsd
else
	cd rtems-libbsd
	git clean -ffdx .
	git submodule update --init --recursive
fi

./waf configure --rtems-bsps="$BSPS" --rtems-tools="$PREFIX" --prefix="$PREFIX" --buildset buildset/default.ini

./waf build install

cd ..
if [ $CLEAN_AFTER_INSTALL -eq 1 ]; then
	rm -rf rtems-libbsd
fi

############# RTEMS net services ############# 

if [ ! -d rtems-net-services ]; then
	git clone https://gitlab.rtems.org/rtems/pkg/rtems-net-services.git --recursive --depth=1
	cd rtems-net-services
else
	cd rtems-net-services
	git submodule update --init --recursive
fi

./waf configure --rtems-bsps="$BSPS" --rtems-tools="$PREFIX" --prefix="$PREFIX"

./waf build install

cd ..
if [ $CLEAN_AFTER_INSTALL -eq 1 ]; then
	rm -rf rtems-net-services
fi

