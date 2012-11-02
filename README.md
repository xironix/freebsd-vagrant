# FreeBSD 9.1 64-bit Vagrant Boxes

This repo contains download links to the following Vagrant boxes:

* [FreeBSD 9.1 64-bit - UFS](https://github.com/downloads/xironix/freebsd-vagrant/freebsd_amd64-ufs.box)
* [FreeBSD 9.1 64-bit - ZFS](https://github.com/downloads/xironix/freebsd-vagrant/freebsd_amd64-zfs.box)

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

Additioanlly, the entire system and kernel were built with clang. =D

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
    
    # Bus support.
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
