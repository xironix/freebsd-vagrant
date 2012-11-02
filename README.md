# FreeBSD 9.1 64-bit Vagrant Boxes

This repo contains download links to the following Vagrant boxes:
[FreeBSD 9.1 64-bit - UFS](https://github.com/downloads/xironix/freebsd-vagrant/freebsd_amd64-ufs.box)
[FreeBSD 9.1 64-bit - ZFS](https://github.com/downloads/xironix/freebsd-vagrant/freebsd_amd64-zfs.box)

## Preloaded Software
* Puppet 3.0.1
* Chef 10.16.2
* VirtualBox Guest Additions 4.1.22
* [Janus: Vim Distribution](https://github.com/carlhuda/janus)

## FreeBSD ZFS Notes

If you are going to use the FreeBSD ZFS box, you shouldn't configure the
box with anything less than 1.5GB of RAM (2GB+ is much preferred).

## Ports & Sources

To slim down the size of these Vagrant boxes, the ports collection and system
sources have been removed. To install a new ports collection and system
sources, do the following:

### Ports Collection

    $ portsnap fetch
    $ portsnap extract

### System Sources

    $ csup /etc/supfile

## Custom Configuration

These Vagrant boxes make use of a custom FreeBSD kernel and make.conf
options. See below for the configurations:

### Custom make.conf

To keep the size of these vagrant boxes small, buildworld has been
executed without many unecessary items, such as X11 or bind9.

    # Use clang as the default compiler
    CC=  clang
    CXX= clang++
    CPP= clang-cpp

    # 2 jobs per CPU
    MAKE_JOBS_NUMBER= 16

    # Compile Time Optimizations
    CPUTYPE?=  native
    CFLAGS=    -O2 -pipe -fno-strict-aliasing
    COPTFLAGS= -O2 -pipe -funroll-loops -ffast-math -fno-strict-aliasing

    # Default Kernel (see /root/kernels)
    KERNCONF=  VAGRANT
    SUPFILE=   /etc/supfile

    # Force Optimized CFLAGS 
    BUILD_OPTIMIZED=         YES
    WITH_CPUFLAGS=           YES
    WITH_OPTIMIZED_CFLAGS=   YES
    OPTIMIZED_CFLAGS=        YES

    # Build static for speed
    BUILD_STATIC=            YES

    # Don't build profiled libraries
    NO_PROFILE=              YES

    # Disable IPv6 support
    NO_INET6=                YES
    WITH_IPV6=               NO
    WITHOUT_IPV6=            YES
    WITHOUT_INET6=           YES

    # Don't build the bind9 server
    WITHOUT_BIND=            YES
    WITHOUT_BIND_DNSSEC=     YES
    WITHOUT_BIND_ETC=        YES
    WITHOUT_BIND_LIBS_LWRES= YES
    WITHOUT_BIND_MTREE=      YES
    WITHOUT_BIND_NAMED=      YES
    WITHOUT_BIND_UTILS=      YES

    # Stuff we don't need for a headless VM
    WITHOUT_BLUETOOTH=       YES
    WITHOUT_FLOPPY=          YES
    WITHOUT_GAMES=           YES
    WITHOUT_USB=             YES
    WITHOUT_WIRELESS=        YES
    WITHOUT_X11=             YES
    WITHOUT_GUI=             YES


### Custom kernel

If you're going to rebuild this kernel, you'll need to make sure that
the system sources have been downloaded and a symbolic link to the
VAGRANT kernel has been placed.

    $ csup /etc/supfile
    $ ln -s /root/kernels/VAGRANT /usr/src/sys/amd64/conf/VAGRANT
