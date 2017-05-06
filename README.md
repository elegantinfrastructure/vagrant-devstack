Running DevStack in Vagrant
===========================

This repository contains yet another set of instructions for building
DevStack under Vagrant. It turns out that this is quite a popular
thing to do.

Building
========

Create a DevStack base box using the `Makefile` provided:

```
$ make build
```

The default release built by the scripts is the ocata release, but a
different release may be specified using the `OS_RELEASE` environment
variable:

```
$ OS_RELEASE=newton make build
```

If you have a mirror of the various OpenStack git repositories needed
to build DevStack you may use the GIT_BASE environment variable to
specify this.  The default is to use https://github.com as the base.

```
$ GIT_BASE=git://192.168.1.36 make build
```

A HTTP proxy may also be specified using the standard `http_proxy`,
`https_proxy` and `no_proxy` environment variables. This speeds up the
build process considerably.

Once the initial VM build process has completed you can run `make
package` to package the VM up and create a local Vagrant box. The box
is called "devstack-$OS_RELEASE" and can then be used as a base box in
further Vagrant configurations.
