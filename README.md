FreeBSD 9.1 ZFS-on-root 64-bit Vagrant Box
==========================================

There aren't all that many FreeBSD Vagrant boxes out there and after
spending the time to create this one, I can understand why. =p

This box comes preloaded with Puppet, Chef, ruby 1.9.3, a fancy vim
environment, and host-only networking pre-configued with an NFS share for
Vagrant.

Given that this box uses ZFS, you shouldn't configure it for any less
than 1.5GB of RAM (2GB+ is much preferred).

Additionally, I recompiled the kernel to remove everything that isn't
needed within Vagrant box, such as USB support, audio support, non-ZFS
file systems, etc... If you need any of this compiled back into the
kernel, open an issue and I'll create a new Vagrant box with what you
need.
