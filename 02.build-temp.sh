#!/usr/bin/env bash
cd $package
mkdir binutils-build
cd binutils-build
../binutils-2.24/configure --prefix=$prefix --disable-nls --disable-werror
make -j8
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin
make install

