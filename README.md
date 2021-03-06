# Project for TBuilder

This is a branch for Hybris AOSP10 aarch64 based Sony Tama port.

This is a repository describing project for building port packages using [TBuilder](https://github.com/rinigus/tbuilder).
To be able to build the packages:

- create RPMS/`target_name` . For example,
  RPMS/SailfishOS-4.0.1.48-aarch64. It is recommended to use a "clean"
  target without droid-hal packages installed, in contrast to the one
  normally used for porting.

- add droid-hal packages to RPMS/`target_name` folder, as done for OBS
  builds. In addition to droid-hal, you can add other packages that
  require droid parts, such as droidmedia. See below for a list.

Here, the following convention is used:

- packages are added submodules under `src`
- their SPEC is linked from `spec`

To add new submodules, use `add_repo` script from TBuilder.

To pull droid packages from local build, run, in PlatformSDK, within
this project directory:
```
./update-droid-hal.sh SailfishOS-4.0.1.48-aarch64
```

To compile, run `tbuilder .` in this directory.


## Notes

For this build to work, there are some adjustments needed in the
target. Below, used `config.yaml` options are explained and how to
prepare the target for building.

Read the text below first before making changes, as some issues could
be encountered which are explained below.

### config.yaml

Few additional packages and conflict resolutions were imposed via
`install` option in `config.yaml`:

- droid-hal-apollo-devel to ensure that at least one of the devel
  packages is installed and there are no conflicts with similar
  packages from other Tama devices (we have 3 of these packages
  in this port). Otherwise, it wouldn't be needed.
- droid-hal-*-kernel-modules are required to parse boot img SPEC
- libhybris is forced instead of mesa GL libs
- bluez5 to force bluez5 support

Out of options, `allow-vendor-change` is used to work around an issue
with installation of build requirements for `droid-hal-version-XXXX`
packages
([details](https://forum.sailfishos.org/t/mb2-allow-to-install-dependencies-with-vendor-change/6057/4)).

Macros defined in the configuration file are consistent with OBS
settings (definition of vendor) or shown as an exmaple (sailfishos).

### Preparing target

There are few changes that have to be done in the target to make the
build working.

Install few packages (change target as needed):

```
sb2 -t SailfishOS-4.0.1.48-aarch64 -R zypper in cpio automake libtool gettext-devel
```

Those packages are either missing from dependencies:

- automake and libtool: missing in ohm-plugins-misc and libdres
- gettext-devel missing in gst-droid

or are in conflict with installed version (`cpio`). See below for
description of issues.


### Issues with cpio and m4

For some reason, `cpio` and `m4` (latter pulled by libtool) don't install
cleanly all the time. You may have to install `cpio`, `libtool` in the
target manually and ignore installation errors.
See https://forum.sailfishos.org/t/cpio-fails-to-install-in-sdk/5934
for details.


## Packages included from HADK

These packages were copied from HADK and were used to initiate the
build:

```
droid-hal-apollo-0.0.6-202103051839.aarch64.rpm
droid-hal-apollo-detritus-0.0.6-202103051839.aarch64.rpm
droid-hal-apollo-devel-0.0.6-202103051839.aarch64.rpm
droid-hal-apollo-img-dtbo-4.14.220-202103051949.aarch64.rpm
droid-hal-apollo-kernel-0.0.6-202103051839.aarch64.rpm
droid-hal-apollo-kernel-dtbo-0.0.6-202103051839.aarch64.rpm
droid-hal-apollo-kernel-modules-0.0.6-202103051839.aarch64.rpm
droid-hal-apollo-tools-0.0.6-202103051839.aarch64.rpm
droid-hal-apollo-users-0.0.6-202103051839.aarch64.rpm
droidmedia-0.20210203.0-1.aarch64.rpm
droidmedia-devel-0.20210203.0-1.noarch.rpm
droid-system-apollo-1-1.aarch64.rpm
droid-system-apollo-h8324-0.0.1-1.aarch64.rpm
miniaudiopolicy-0.1.0-202103051923.aarch64.rpm
```
