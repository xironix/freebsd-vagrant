# FreeBSD 9.1-RELEASE 64-bit Vagrant Boxes

This repo contains download links to the following Vagrant boxes:

* [FreeBSD 9.1 64-bit - UFS](https://s3.amazonaws.com/vagrant_boxen/freebsd_amd64_ufs.box)
* [FreeBSD 9.1 64-bit - ZFS](https://s3.amazonaws.com/vagrant_boxen/freebsd_amd64_zfs.box)

# New base boxes coming within 24 hours!

With the new base boses, I will be moving to google cloud storage and closing
down the Amazon S3 links. Be warned! =p

Also, the current "config" and "utils" directories are mostly works in progress
with the new build. Haven't decided to use custom build scripts or to play
around with Veewee. If Veewee allows me to build one base box that gets cloned
to a second box, I'm sold! There's a reason I have small vboxen. ;)

Basically, the way I have it setup right now is I build a single FreeBSD UFS
setup under VirtualBox, then I clone that system to two fresh vdi disks (one for
UFS and one for ZFS). This allows me to keep the size super small and only build
a single system that gets exported to UFS and ZFS vagrant boxes.

We shall see what I can accomplish today/tomorrow. Watch this space.
