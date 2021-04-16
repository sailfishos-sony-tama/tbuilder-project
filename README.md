# Project for TBuilder

This is a branch for Hybris AOSP10 aarch64 based Sony Tama port.

This is a repository describing project for building port packages using [TBuilder](https://github.com/rinigus/tbuilder).
To be able to build the packages:

- create RPMS/`target_name` . For example, RPMS/SailfishOS-4.0.1.48-aarch64. It is recommended to use
  a "clean" target without droid-hal packages installed, in contrast to the one normally used for porting.

- add droid-hal packages to RPMS/`target_name` folder, as done for OBS builds. In addition to droid-hal, you can
  add other packages that require droid parts, such as droidmedia


Here, the following convention is used:

- packages are added submodules under `src`
- their SPEC is linked from `spec`
