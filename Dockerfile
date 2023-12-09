FROM debian:stable-slim

ARG arch
RUN sudo apt-get update && sudo apt-get install -y python3 gcc g++ llvm-dev git sed gawk libpython3.9-dev

# some tools are in /bin, we need them in /usr/bin
#RUN sudo ln -s /bin/sed /usr/bin/sed
#RUN sudo ln -s /bin/bzip2 /usr/bin/bzip2
#RUN sudo ln -s /bin/chgrp /usr/bin/chgrp
#RUN sudo ln -s /bin/chown /usr/bin/chown
#RUN sudo ln -s /bin/grep /usr/bin/grep

# Compile the thing.
RUN ./rtems-source-builder/source-builder/sb-set-builder --prefix "/usr" 6/rtems-${arch}.bset --log rsb.log || cat rsb.log

