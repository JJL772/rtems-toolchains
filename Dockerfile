FROM debian:stable-slim

ARG arch
RUN apt-get update && apt-get install -y --no-install-recommends python3 gcc g++ git llvm-dev sed gawk libpython3-dev python3 python-is-python3

RUN apt-get install -y --no-install-recommends flex bison bzip2 unzip make xz-utils patch

COPY . /sb

RUN cd ./sb/rtems-source-builder && patch -p1 < ../gmp-url.patch && cd ..

# Compile the thing.
RUN /sb/rtems-source-builder/source-builder/sb-set-builder --prefix "/usr" 6/rtems-${arch}.bset --macros /sb/macros.mc

