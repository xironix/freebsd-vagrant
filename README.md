# FreeBSD 9.1-RELEASE 64-bit Vagrant Boxes

This repo contains download links to the following Vagrant boxes:

* [FreeBSD 9.1 64-bit - UFS](https://s3.amazonaws.com/vagrant_boxen/freebsd_amd64_ufs.box)
* [FreeBSD 9.1 64-bit - ZFS](https://s3.amazonaws.com/vagrant_boxen/freebsd_amd64_zfs.box)

# New base boxes coming within 24 hours!

With the new base boses, I will be moving to google cloud storage and closing
down the Amazon S3 links. Be warned! =p

Also, the current "config" and "utils" directories are mostly works in progress
with the new build. Haven't decided to use custom build scripts or to play
around with Veewee. Leaning towards Veewee if I can manage to create a template
that allows one to buildworld/kernel (there's a reason I have small vboxen!).
