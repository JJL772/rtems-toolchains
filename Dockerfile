FROM debian:11-slim

ARG version
ARG arch
RUN apt-get update && apt-get install -y --no-install-recommends python3 gcc g++ git llvm-dev sed gawk libpython3-dev python3 python-is-python3

RUN apt-get install -y --no-install-recommends flex bison bzip2 unzip make xz-utils patch

COPY . /sb

# Compile the thing.
RUN cd /sb && mkdir -p /opt/rtems/${version} && /sb/rtems-source-builder/source-builder/sb-set-builder --prefix /opt/rtems/${version} ${version}/rtems-${arch}.bset --macros /sb/macros.mc && \
	cd / && rm -rf /sb

