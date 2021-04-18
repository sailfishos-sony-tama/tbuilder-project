# Project for TBuilder

This is a branch for Hybris AOSP10 aarch64 based Sony Tama port.

This is a repository describing project for building port packages using [TBuilder](https://github.com/rinigus/tbuilder).
To be able to build the packages:

- create RPMS/`target_name` . For example,
  RPMS/SailfishOS-4.0.1.48-aarch64. It is recommended to use a "clean"
  target without droid-hal packages installed, in contrast to the one
  normally used for porting. Unfortunately, currently some adjustments
  will be needed, as described below.

- add droid-hal packages to RPMS/`target_name` folder, as done for OBS
  builds. In addition to droid-hal, you can add other packages that
  require droid parts, such as droidmedia

Here, the following convention is used:

- packages are added submodules under `src`
- their SPEC is linked from `spec`

To add new submodules, use `add_repo` script from TBuilder.

To compile, run `tbuilder .` in this directory.


## Additional notes

Some adjustments of the target were required, induced by conflicts
with the already installed packages. It is suggested to start with the
builds and make the adjustments when they fail. This should result in
the required libhybris packages available for install.

To make adjustments, remove snapshot, as in

```
sdk-assistant rm SailfishOS-4.0.1.48-aarch64.h8324
```

install the required packages and continue building.


### bluez5

Had to install bluez5:

```
sb2 -t SailfishOS-4.0.1.48-aarch64 -R -msdk-install zypper in bluez5
```

to be able to compile `bluebinder`.

### hybris EGL

As there is a conflict with Mesa, had to install

```
sb2 -t SailfishOS-4.0.1.48-aarch64 -R -msdk-install \
  zypper -p RPMS/SailfishOS-4.0.1.48-aarch64 in \
  RPMS/SailfishOS-4.0.1.48-aarch64/libhybris-libEGL-0.0.0-1.aarch64.rpm \
  RPMS/SailfishOS-4.0.1.48-aarch64/libhybris-libGLESv2-0.0.0-1.aarch64.rpm \
  RPMS/SailfishOS-4.0.1.48-aarch64/libhybris-libwayland-egl-0.0.0-1.aarch64.rpm
```

### droid-hal-apollo-img-boot

Cannot build as version is determined from the installed kernel. As it
is not defined while running `rpmspec`, whole parsing fails. Not sure
how to approach it.