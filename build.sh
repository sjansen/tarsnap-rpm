#!/bin/bash

set -e
PACKAGE=tarsnap
VERSION=1.0.35

if [ -n "$1" ]; then
    VERSION="$1"
fi

TAR_URL="https://www.tarsnap.com/download/tarsnap-autoconf-${VERSION}.tgz"

PKGDEPS="redhat-rpm-config rpmdevtools rpmlint"
MINDEPS="gcc glibc-devel make openssl-devel zlib-devel e2fsprogs-devel"
EXTDEPS="libacl-devel libattr-devel bzip2-devel xz-devel"
MISSING=""
for I in $PKGDEPS $MINDEPS $EXTDEPS
do
    if ! rpm -q "$I"; then
        MISSING="$I $MISSING"
    fi
done
if [ -n "$MISSING" ]; then
    sudo yum install -y $MISSING
fi

if [ ! -d ~/rpmbuild/SOURCES/ ]; then
    rpmdev-setuptree
fi

TARBALL="tarsnap-autoconf-${VERSION}.tgz"
wget -c "$TAR_URL" -O "$TARBALL"
cp "$TARBALL" ~/rpmbuild/SOURCES/"$TARBALL"

SPEC=~/rpmbuild/SPECS/"${PACKAGE}.spec"
cp "${PACKAGE}.spec.tmpl" "$SPEC"
sed -i "s/\${VERSION}/${VERSION}/" "$SPEC"

rpmbuild -bb "$SPEC"
mv ~/rpmbuild/RPMS/*/${PACKAGE}*-${VERSION}-*.rpm ./

rpmlint -f "${PACKAGE}.rpmlint" "$SPEC" ${PACKAGE}*-${VERSION}-*.rpm
