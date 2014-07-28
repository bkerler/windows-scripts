#!/bin/bash

GNUTLS_VERSION="3.2.16"

. mingw.sh

if [ ! -f gnutls-$GNUTLS_VERSION.tar.lz ] ; then
	wget ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-$GNUTLS_VERSION.tar.lz
fi
rm -rf gnutls-$GNUTLS_VERSION
tar --lzip -xf gnutls-$GNUTLS_VERSION.tar.lz
rm -rf gnutls

pushd gnutls-$GNUTLS_VERSION

touch -r lib/Makefile.am retained-timestamp

wget https://gitorious.org/gnutls/gnutls/commit/410970f8777f2fe7a421e94999e542d023f35229.patch
wget https://github.com/attilamolnar/gnutls/commit/e0e78d73867f65cc5af08d49e631e3b0e2fb051e.patch

patch -p1 < 410970f8777f2fe7a421e94999e542d023f35229.patch
patch -p1 < e0e78d73867f65cc5af08d49e631e3b0e2fb051e.patch

touch -r retained-timestamp lib/Makefile.am

export LDFLAGS="-L$PREFIX/gmp/lib"
export PKG_CONFIG_PATH="$PREFIX/nettle/lib/pkgconfig"
export GMP_CFLAGS="-I$PREFIX/gmp/include"
export GMP_LIBS="-lgmp"
./configure --prefix=$PREFIX/gnutls --host=$TOOLCHAINPREFIX --enable-shared --disable-static
make
make install

popd

$TOOLCHAINPREFIX-dlltool --def gnutls/bin/libgnutls-28.def --dllname libgnutls-28.dll --output-lib gnutls/lib/libgnutls-28.lib

