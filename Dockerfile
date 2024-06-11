FROM debian:stable-slim

ARG arch
RUN apt-get update && apt-get install -y python3 gcc g++ llvm-dev git sed gawk libpython3-dev python3 python-is-python3

RUN apt-get install -y flex bison bzip2 unzip make xz-utils

COPY ./rtems-source-builder /sb
COPY macros.mc /sb/macros.mc

# Compile the thing.
RUN /sb/source-builder/sb-set-builder --prefix "/usr" 6/rtems-${arch}.bset --macros /sb/macros.mc --log rsb.log

