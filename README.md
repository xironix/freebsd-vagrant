# FreeBSD 9.1-RELEASE 64-bit Vagrant Boxes

This repo contains download links to the following Vagrant boxes:

* [FreeBSD 9.1 64-bit - UFS](https://s3.amazonaws.com/vagrant_boxen/freebsd_amd64_ufs.box)
* [FreeBSD 9.1 64-bit - ZFS](https://s3.amazonaws.com/vagrant_boxen/freebsd_amd64_zfs.box)

## Updating - Current with 9.1-RELEASE-p1

I will keep these Vagrant boxes up to date with the 9.1-RELEASE branch. For the
time being, you can probably expect these Vagrant boxes to be updated once or
twice a month.

Additionally, I'm more than happy to accomodate any special requests with
respect to any default software installed or even custom Vagrant boxes based on
9.1-RELEASE-p1.

**UPDATE:** The URL for the Vagrant boxes has changed. Please update your
Vagrantfile to reflect the changes.

**IMPORTANT:** With the release of Vagrant 1.1.0 through to 1.1.2 (support in
future versions remains to be seen), mounting NFS shares fails. With much tial
and error, I was forced to write a shell provisioning script to mount NFS shares
manually. Please see [Vagrant & FreeBSD](#vagrant--freebsd)

### Change Log

Moved this section to [CHANGELOG.md](CHANGELOG.md)

## Preloaded Software
This is not a complete list of installed software, but more of a list of
semi-noteable installations. As with
[@marcoVermeulen](https://github.com/marcoVermeulen) and his request for
OpenJDK 7 to be included, I am open to preloading other sofrware packages upon
request.

However, it should be noticed that I will always attempt to keep the Vagrant box
as small as possible. As such, I will tend to avoid compiling anything related
to Xorg, LAMP servers, other other related services.

### Vagrant Requirements
* Puppet 3.1.1
* Chef 11.4.0
* Ruby 1.9
* sudo 1.8.6
* VirtualBox Guest Additions 4.2.6

### Other Software
* OpenJDK 7
* vim 7.3.669
* wget 1.14
* curl 7.24
* git 1.8.2
* subversion 1.7.8
* rsync 3.0.9
* bash 4.2.42

## Vagrant & FreeBSD

FreeBSD is a special snowflake when it comes to Vagrant, and thus we need to
provide some specific Vagrantfile options. I opted not to package this file
within the box, as some may not wish to setup shared folders.

### NFS Exports Template

On the host system, you will have to manually define an NFS export. Currently I
have only tested this on [Gentoo Linux](http://gentoo.org), but it will probably
work on Mac OS X as well as other Linux distributions.

Here is an example `/etc/exports` file for the NFS export. Change `/EXPORT/DIR`
to the directory that contains your Vagrant setup. You can use any higher
directory as NFS exports are recursive.

    # /etc/exports: NFS file systems being exported.  See exports(5).
    /EXPORT/DIR 127.0.0.1(rw,async,no_subtree_check,insecure,anonuid=1001,anongid=1001)

### Vagrantfile Template

Use the following template if you're planning on using shared folders, as the
VirtualBox guest additions do not support shared folders with FreeBSD -- we need
to use NFS.

    # -*- mode: ruby -*-
    # vi: set ft=ruby :

    # We need to use the v1 configuration to disable shared folders
    Vagrant.configure("1") do |config|
      # Vagrant 1.1.x refuses to play nicely with FreeBSD and NFS.
      # As such, we have to disable shared folders.
      config.vm.share_folder "vagrant-root", nil, ".", guestpath: nil
    end

    Vagrant.configure("2") do |config|
        config.vm.box = "FreeBSD"
        config.vm.guest = :freebsd

        # UFS Box or ZFS Box, you choose!
        config.vm.box_url = "https://s3.amazonaws.com/vagrant_boxen/freebsd_amd64_ufs.box"

        # Customize the virtual machine environment
        config.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
        end

        # Change s.args to reflect your configuration
        config.vm.provision :shell do |s|
            s.inline = "mkdir -p $2 ; \
                mount $(route get 127.1.1.1 | tr -d ' ' | grep gateway | \
                awk -F':' '{print $2}'):$1 $2"
            s.args = "/SOURCE/DIR /DEST/DIR"
        end
    end

The provisioning script grabs the default gateway for the NFS hsot. Be sure to
change `s.args` to reflect your own source and destination directories.

**NOTE:** It seems that the provisioning shell script does not run
automatically. As such, I suggest start vagrant with `vagrant up; vagrant
provision`.

## FreeBSD ZFS Notes

If you are going to use the FreeBSD ZFS box, you shouldn't configure the box
with anything less than 1.5GB of RAM (2GB+ is much preferred).

## Ports & Sources

To slim down the size of these Vagrant boxes, the ports collection and system
sources have been removed. To install a new ports collection and system sources,
do the following:

### Ports Collection

This will install a fresh ports tree from which you can install ports from
scratch. This must be done on any fresh Vagrant boxes if you want to install any
ports.

    $ portsnap fetch
    $ portsnap extract

To update an existing ports tree, simply run the following.

    $ portsnap fetch
    $ portsnap update

To install a port from the ports tree, I generally use portmaster. The
convention for using portmaster is as follows:

    $ portmaster -BCD /usr/ports/foo/bar

You can generally omit the /usr/ports part for installing ports with portmaster.
Additionally, if you want to upgrade all installed ports, run the following
command:

    $ portmaster -BCDa

### System Sources

**NOTE:** CVSup as been deprecated in favour of subversion. Use one of the
following commands to checkout the system sources depending on your location.

**US West Coast:**

    $ svn co http://svn0.us-west.freebsd.org/base/release/9.1.0/ /usr/src

**US East Coast:**

    $ svn co http://svn0.us-east.freebsd.org/base/release/9.1.0/ /usr/src

Use /base/head if you want CURRENT.

To update the sources, simply do the following:

    $ cd /usr/src
    $ svn update

## Custom Configuration

These Vagrant boxes make use of a custom FreeBSD kernel and `make.conf` options.
See below for the configurations:

### Custom make.conf

To keep the size of these vagrant boxes small, buildworld has been executed
without many unecessary items, such as X11 or bind9.

**IMPORTANT:** Make sure you change `MAKE_JOBS_NUMBER` to something sane for
your configuration.

Additioanlly, the entire system and kernel were built with clang. =D

    # Use clang as the default compiler
    CC=  clang
    CXX= clang++
    CPP= clang-cpp

    # 2 jobs per CPU
    MAKE_JOBS_NUMBER= $(sysctl -a | grep hw.ncpu | awk '{print $2"*2"}' | bc)

    # Compile Time Optimizations
    CPUTYPE?=  native
    CFLAGS=    -Os -mtune=generic -pipe
    COPTFLAGS= -Os -mtune=generic -pipe

    # Update to new PKGNG package manager
    WITH_PKGNG= YES

    # Default Kernel (see /root/kernels)
    KERNCONF=   VAGRANT

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
    WITHOUT_NTP=             YES # time sync is handled by VirtualBox

    # Current Perl Version
    PERL_VERSION=5.14.2

### Custom kernel

If you're going to rebuild this kernel, you'll need to make sure that the system
sources have been downloaded and a symbolic link to the VAGRANT kernel has been
placed.

    $ csup /etc/supfile
    $ ln -s /root/kernels/VAGRANT /usr/src/sys/amd64/conf/VAGRANT

Below is the custom kernel used in these boxes.

    #
    # VAGRANT -- Minimal kernel configuration file for FreeBSD/amd64
    #
    # For more information on this file, please read the config(5) manual page,
    # and/or the handbook section on Kernel Configuration Files:
    #
    #    http://www.FreeBSD.org/doc/en_US.ISO8859-1/books/handbook/kernelconfig-config.html
    #
    # The handbook is also available locally in /usr/share/doc/handbook
    # if you've installed the doc distribution, otherwise always see the
    cpu     HAMMER              # 64-bit kernel
    ident   VAGRANT

    options   SCHED_ULE         # ULE scheduler
    options   PREEMPTION        # Enable kernel thread preemption
    options   INET              # InterNETworking
    options   SCTP              # Stream Control Transmission Protocol
    options   FFS               # Berkeley Fast Filesystem
    options   SOFTUPDATES       # Enable FFS soft updates support
    options   UFS_ACL           # Support for access control lists
    options   UFS_DIRHASH       # Improve performance on big directories
    options   UFS_GJOURNAL      # Enable gjournal-based UFS journaling
    options   MD_ROOT           # MD is a potential root device
    options   NFSCL             # New Network Filesystem Client
    options   NFSD              # New Network Filesystem Server
    options   NFSLOCKD          # Network Lock Manager
    options   MSDOSFS           # MSDOS Filesystem
    options   CD9660            # ISO 9660 Filesystem
    options   PROCFS            # Process filesystem (requires PSEUDOFS)
    options   PSEUDOFS          # Pseudo-filesystem framework
    options   GEOM_PART_GPT     # GUID Partition Tables.
    options   GEOM_LABEL        # Provides labelization
    options   COMPAT_FREEBSD32  # Compatible with i386 binaries
    options   COMPAT_FREEBSD7   # Seems to be required by OpenJDK 7
    options   SCSI_DELAY=500    # Delay (in ms) before probing SCSI
    options   KTRACE            # ktrace(1) support
    options   STACK             # stack(9) support
    options   SYSVSHM           # SYSV-style shared memory
    options   SYSVMSG           # SYSV-style message queues
    options   SYSVSEM           # SYSV-style semaphores
    options   _KPOSIX_PRIORITY_SCHEDULING # POSIX P1003_1B real-time extensions
    options   PRINTF_BUFR_SIZE=128        # Prevent printf output being interspersed.
    options   KBD_INSTALL_CDEV  # install a CDEV entry in /dev
    options   HWPMC_HOOKS       # Necessary kernel hooks for hwpmc(4)
    options   AUDIT             # Security event auditing
    options   MAC               # TrustedBSD MAC Framework
    options   INCLUDE_CONFIG_FILE # Include this file in kernel

    # Make an SMP-capable kernel by default
    options   SMP     # Symmetric MultiProcessor Kernel

    # CPU frequency control
    #device    cpufreq

    # Bus support
    device    acpi
    device    pci

    # Floppy drives
    device    fdc

    # ATA controllers
    device    ahci          # AHCI-compatible SATA controllers
    device    ata           # Legacy ATA/SATA controllers
    options   ATA_CAM       # Handle legacy controllers with CAM
    options   ATA_STATIC_ID # Static device numbering

    # ATA/SCSI peripherals
    device    scbus # SCSI bus (required for ATA/SCSI)
    device    da    # Direct Access (disks)
    device    cd    # CD
    device    ctl   # CAM Target Layer

    # atkbdc0 controls both the keyboard and the PS/2 mouse
    device    atkbdc  # AT keyboard controller
    device    atkbd   # AT keyboard
    device    psm     # PS/2 mouse

    device    vga     # VGA video card driver
    options   VESA    # Add support for VESA BIOS Extensions (VBE)

    # syscons is the default console driver, resembling an SCO console
    device    sc
    options   SC_PIXEL_MODE # add support for the raster text mode

    # PCI Ethernet NICs.
    device    em    # Intel PRO/1000 Gigabit Ethernet Family

    # Pseudo devices.
    device    loop      # Network loopback
    device    random    # Entropy device
    device    ether     # Ethernet support

    # The `bpf' device enables the Berkeley Packet Filter.
    # Be aware of the administrative consequences of enabling this!
    # Note that 'bpf' is required for DHCP.
    device    bpf   # Berkeley packet filter
