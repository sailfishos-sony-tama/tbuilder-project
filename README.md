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
  require droid parts, such as droidmedia

Here, the following convention is used:

- packages are added submodules under `src`
- their SPEC is linked from `spec`

To add new submodules, use `add_repo` script from TBuilder.

To compile, run `tbuilder .` in this directory.


## Additional notes

Few additional packages and conflict resolutions were imposed via
`install` option in `config.yaml`:

- bluez5 is forced and replaces bluez4 in the target 
- droid-hal-apollo-kernel-modules is required to parse boot img SPEC
- cpio is required for building boot img
- libhybris is forced instead of mesa GL libs
- ohm as hybris-10 AOSP port requires newer ohm. As compiled version has 
  different vendor, resolution has to be enforced
- automake and libtool: missing in ohm-plugins-misc and libdres
- gettext-devel missing in gst-droid

