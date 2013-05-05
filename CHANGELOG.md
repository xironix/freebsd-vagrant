# Change Log

## May 5, 2013

### Bug Fixes
* Enabled IPv6 support to avoid errors with some ports. Additionally, IPv6 will
be enabled globally by default.

### Improvements
* Switched to svn ports tree
* Created a local new build procedure (this is for @xironix's use)
* Added all relevant config files and scripts to git.
* Upgraded to chef 11.4.4
* Upgraded to puppet 3.1.1
* Rebuilt minimal world & kernel
* Added symbolic link for /usr/local/bin/bash to /bin/bash for script
  compatibility.
* Rebuilt Vagrant boxes from scratch to clear cruft.
* No longer using Canada/Pacific As the timezone, switched to UTC.

## March 26, 2013

### Bug Fixes
* Updated instructions on how to make Vagrant play nicely with NFS shared
  folders.

## March 25, 2013

### Improvements
* Configured `/etc/make.conf` to automatically detect number of CPUs and
  multiply by two.

### Bug Fixes
* Added vagrant user to sudoers file. Apologies to anyone this affected in the
last 24 hours.
* Added `config.vm.box_url` back to the bundled Vagrantfile.

## March 24, 2013

### Improvements
* Reninstalled all ports with minimal USE flags. If this causes any problems,
  please open an issue and I can make the necessary corrections.
* Changed `-O2` to `-Os` in `make.conf` in an attempt to further reduce the
  image size.

## March 23, 2013

### Improvements
* Renamed S3 path `VagrantBoxen` to `vagrant_boxen` to follow S3 best practices.
  Additionally, boto refused to work with upper case S3 buckets.

## March 22, 2013

### Bug Fixes
* Created a shell provisioning script to manually mount NFS shares. Vagrant
  1.1.2 refuses to allow FreeBSD to use NFS synced folders (see [Vagrant issue
  #1499](https://github.com/mitchellh/vagrant/issues/1499).
* Corrected insane `MAKE_JOBS_NUMBER` in `/etc/make.conf`.

### Improvements
* Included OpenJDK 7 as requested by [@marcoVermeulen](https://github.com/marcoVermeulen).
Solves [issue #5](https://github.com/xironix/freebsd-vagrant/issues/5)
* Updated `README.md` to account for changes in Vagrant 1.1.2 (what a pain!!).
* Configured basic bash completion (see `/usr/local/etc/bash_completion.d`).
* Updated to Puppet 3.1.1 and Chef 11.4.0.
* Configured basic vim environment using Vundle.

## March 21, 2013

### Bug Fixes
* Changed `~/.bashrc` to be more sane as well as removing some of my personal
  cruft. =O

### Improvements
* Compiled threaded perl.
* Upgraded to Ruby 1.9.3p392.
* Removed any unnecessary ports.
* Changed default umask to 0027
* Removed the Janus vim environment (it was a tad too opressive in setting
  defaults)
* Added some useful bash aliases for FreeBSD (see `~/.bash_aliases`)

## February 10, 2013

## Improvements
* Bundled Vagrantfile now includes a link to where the box came from
  (`config.vm.box_url`).
* Updated ports for both the UFS and ZFS Vagrant boxes.

## January 3, 2013

### Bug Fixes
* Added `fsck_y_enable="YES"` to `/etc/rc.conf`. Solves [issue #2](https://github.com/xironix/freebsd-vagrant/issues/2)

### Improvements
* Updated both the UFS and ZFS Vagrant boxes to 9.1-RELEASE.
* VirtualBox images are now hosted with Amazon S3.
* VirtualBox Guest Additions updated to 4.2.6
