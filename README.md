# RTEMS Toolchains

This repository contains automatically built Docker images containing RTEMS, libbsd and the associated toolchain.

Dependabot is used to bump the rtems-source-builder submodule as new commits land there.

## `rtems-6-toolchains` image

This image contains the toolchain used to compile RTEMS 6. It's installed to /usr/local and is already on your PATH when you start the container.

The `riscv` and `microblaze` targets are currently disabled due to build failures. In the case of `riscv`, it's more of a limitation of GitHub's runners, as it runs out of disk space during the build.
`microblaze` has an unrelated failure that will likely be fixed upstream in the near future.

### Usage

```sh
$ docker pull ghcr.io/jjl772/rtems-6-toolchains:powerpc
$ docker run --rm ghcr.io/jjl772/rtems-6-toolchains:powerpc powerpc-rtems6-gcc --version
```

See [this page](https://github.com/JJL772/rtems-toolchains/pkgs/container/rtems-6-toolchains) for a full list of tags.

## `rtems-6` image

This image is based on the `rtems-6-toolchains` image and contains a build of RTEMS and libbsd installed to /usr/local. Not every BSP is compiled, only the BSPs relevant to EPICS base. See `setup-rtems.bash` for the list, more can be added as needed.

In the future, this image may be tagged based on architecture _and_ BSP, depending on if the GitHub runners start running out of disk space during the build.

TODO: Add RTEMS network services package for NTP

### Usage

```
$ docker pull ghcr.io/jjl772/rtems-6:powerpc
$ docker run --rm ghcr.io/jjl772/rtems-6:powerpc ls /usr/local/powerpc-rtems6
```
