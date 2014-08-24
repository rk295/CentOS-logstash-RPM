#!/bin/bash

# I did this because the official logstash RPMs do not work on CentOS 5. 
# They are signed in a way which only works >=6, while they *could* be signed
# in a way which works in 5 and >=6 they currently (23/08/2014) are not.
#
# The guts of this is from the pkg/ dir of the main logstash source, but is 
# reduced to the bare minimum to build a rpm for centos. 
#
# This ought to work for future versions as long as they continue to ship a 
# .tar.gz and don't revert to a .jar. For a new version just change $VERSION
# and increment $EPOCH
#

VERSION="1.4.2"
RELEASE="1"
EPOCH="1"
URL="http://logstash.net"
DESCRIPTION="An extensible logging pipeline"

destdir=build
prefix=opt/logstash

echo "Building package version: $VERSION release: $RELEASE epoch: $EPOCH"

if [ "$destdir/$prefix" != "/" -a -d "$destdir/$prefix" ] ; then
  echo "Cleaning build dir $destdir/$prefix"
  rm -rf "$destdir/$prefix"
fi

mkdir -p $destdir/$prefix

tar="logstash-$VERSION.tar.gz"
if [ ! -f "$tar" ] ; then
  echo "Unable to find $tar"
  exit 1
fi

echo "Extracting logstash-$VERSION.tar.gz"
tar -C $destdir/$prefix --strip-components 1 -zxpf $tar

echo "Installing some default files"
mkdir -p $destdir/etc/logrotate.d
mkdir -p $destdir/etc/sysconfig
mkdir -p $destdir/etc/init.d
mkdir -p $destdir/etc/logstash/conf.d
mkdir -p $destdir/opt/logstash/tmp
mkdir -p $destdir/var/lib/logstash
mkdir -p $destdir/var/run/logstash
mkdir -p $destdir/var/log/logstash
chmod 0755 $destdir/opt/logstash/bin/logstash
install -m644 files/logrotate.conf $destdir/etc/logrotate.d/logstash
install -m644 files/logstash.default $destdir/etc/sysconfig/logstash
install -m755 files/logstash.sysv.redhat $destdir/etc/init.d/logstash
install -m644 files/logstash-web.default $destdir/etc/sysconfig/logstash
install -m755 files/logstash-web.sysv.redhat $destdir/etc/init.d/logstash-web

echo "Running fpm"
fpm -s dir -t rpm -n logstash -v "$VERSION" \
  -a noarch --iteration "1_${RELEASE}" \
  --epoch $EPOCH \
  --url "$URL" \
  --description "$DESCRIPTION" \
  -d "jre >= 1.6.0" \
  --vendor "Elasticsearch" \
  --license "ASL 2.0" \
  --rpm-use-file-permissions \
  --rpm-user root --rpm-group root \
  --before-install centos/before-install.sh \
  --before-remove centos/before-remove.sh \
  --after-install centos/after-install.sh \
  --config-files etc/sysconfig/logstash \
  --config-files etc/logrotate.d/logstash \
  -f -C $destdir .
