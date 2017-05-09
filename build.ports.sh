#!/bin/sh
# $dodge: build.ports.sh,v 1.25 2013/03/11 21:27:26 dodge Exp $
#
# build all the ports I want normally want.

export ftp_proxy=http://dodge:webshite@proxy.dmumford.com:8080/
export http_proxy=http://dodge:webshite@proxy.dmumford.com:8080/
export https_proxy=http://dodge:webshite@proxy.dmumford.com:8080/

cp ports-patches/zzz_dodge_rtorrent.diff /usr/ports/net/rtorrent/patches || exit 1

PACKAGES="
	archivers/bzip2
	archivers/unrar
	archivers/unzip
	archivers/zip
	comms/minicom
	databases/db/v4:no_java
	devel/ddd
	devel/git
	editors/vim:no_x11
	lang/lua
	lang/python/2.7
	lang/ruby/1.9:no_x11
	mail/alpine
	mail/fetchmail
	mail/imap-uw
	mail/mboxgrep
	mail/mutt/stable
	mail/postfix/stable:sasl2
	mail/procmail
	misc/screen
	net/cvsync
	net/flowd
	net/irssi
	net/nmap
	net/ntp
	net/openvpn
	net/rsync
	net/rtorrent
	net/silc-client
	net/silc-server
	net/wget
	security/gnupg
	shells/bash
	shells/zsh
	sysutils/smartmontools
	textproc/ispell
	www/links
	www/squid
"
#	net/nagios

for pkg in ${PACKAGES} ; do
	p=`echo "${pkg}" | awk -F: '{print $1}'`
	f=`echo "${pkg}" | awk -F: '{print $2}'`
	if [ "$f" = "" ]; then
		unset FLAVOR
	else
		export FLAVOR="${f}"
	fi

	echo "pkg:${pkg} ${FLAVOR}"

	pkg_info | awk '{print $1}' | xargs pkg_delete
	# cd /usr/ports/${p} && make all package install && make clean distclean && pkg_delete ${p} || exit 1
	cd /usr/ports/${p} && make all package install
	if [ $? != 0 ] ; then
		FAIL="${FAIL}${pkg} "
	fi

done

echo "These failed: ${FAIL}"
