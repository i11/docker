#!/bin/bash -e

## requires running as root because filesystem package won't install otherwise,
## giving a cryptic error about /proc, cpio, and utime. As a result, /tmp
## doesn't exist.
[ $( id -u ) -eq 0 ] || { echo "must be root"; exit 1; }

tmpdir=$( mktemp -d )
trap "echo removing ${tmpdir}; rm -rf ${tmpdir}" EXIT

febootstrap \
    -u http://mirrors.mit.edu/centos/6.5/updates/x86_64/ \
    -i centos-release \
    -i yum \
    -i iputils \
    -i tar \
    -i which \
    -i sudo \
    -i logrotate \
    centos65 \
    ${tmpdir} \
    http://mirror.nsc.liu.se/CentOS/6.5/os/x86_64/

febootstrap-run ${tmpdir} -- sh -c 'echo "NETWORKING=yes" > /etc/sysconfig/network'

## set timezone of container to UTC
febootstrap-run ${tmpdir} -- ln -f /usr/share/zoneinfo/Etc/UTC /etc/localtime

febootstrap-run ${tmpdir} -- yum clean all

# Update sudoers
febootstrap-run ${tmpdir} -- sed -i 's/Defaults\s*requiretty/# Defaults    requiretty/' /etc/sudoers
febootstrap-run ${tmpdir} -- sed -i 's/^[ \t]*#[ \t]*\(%wheel[ \t].*NOPASSWD.*\)$/\1/' /etc/sudoers

## xz gives the smallest size by far, compared to bzip2 and gzip, by like 50%!
febootstrap-run ${tmpdir} -- tar -cf - . | xz > centos65.tar.xz
