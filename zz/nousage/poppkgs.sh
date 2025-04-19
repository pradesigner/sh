#!/usr/bin/env zsh
# populates pkgs from /var/db/pkg

DBPKGDIR=/var/db/pkg
PKGSDIR=/data/FreeBSD/7.0/packages
FTPLOC=ftp://ftp1.freebsd.org/pub/FreeBSD/ports/i386/packages-7.0-release/All/

cd $PKGSDIR

for f in $DBPKGDIR/*; do
    thefile=${f##*/}.tbz
    if [[ -f $PKGSDIR/$thefile ]]; then
	print $thefile is there
    else
	print $thefile is not there
	print getting it now ...
	wget $FTPLOC/$thefile
    fi
done
