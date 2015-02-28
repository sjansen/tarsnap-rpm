Tarsnap for CentOS, Fedora, and RHEL
===================================

Create your own tarsnap client RPM for CentOS, Fedora, or RHEL.

Tested on CentOS 6, CentOS 7, and Fedora 21.

Quickstart
----------

Package the default version of tarsnap:

    ./build.sh

Package a specific version of tarsnap:

    ./build.sh 1.0.35

Backup a system:

    rpm -i tarsnap*.rpm
    sudo tarsnap-keygen --machine $(hostname) \
        --keyfile /etc/tarsnap.key \
        --user tarsnap-user@example.com
    sudo tarsnap -cf etc-$(date +%Y-%m-%d-%H-%M) /etc

Details
-------

This project doesn't include the tarsnap client source code. Instead,
`build.sh` downloads it from tarsnap.com.

While it is safest to build packages as a non-privileged user, if you
like to live dangerously `build.sh` installs dependencies when run by
a user with sudo privileges.

**WARNING**: Running `build.sh` has side effects for the build user.
Specifically, `~/.rpmmacros` and `~/rpmbuild/` will be added or
modified.

To build as a non-privileged user:

    sudo yum install redhat-rpm-config rpmdevtools rpmlint
    sudo yum install gcc glibc-devel make openssl-devel zlib-devel e2fsprogs-devel
    sudo yum install libacl-devel libattr-devel bzip2-devel xz-devel
    sudo useradd -m builduser
    sudo cp -r tarsnap-rpm/ ~builduser/tarsnap-rpm
    sudo chown -R builduser: ~builduser/tarsnap-rpm
    sudo -i -u builduser
    cd ~/tarsnap-rpm
    ./build.sh
    mv -v *.rpm /tmp
    exit
    ls /tmp/*.rpm
