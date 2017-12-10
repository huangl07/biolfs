#!/usr/bin/env bash
export prefix=$HOME/temp-build/
export package=$HOME/package/8.1-rc1/
export CFLAGS="-fPIC"
function build(){
	make -j8
	make install
	cd $package
	echo $1," complete!"
}
function prebuild(){
	tar -xvf $1.tar.*
	if [ -d $1 ]; then 
		cd $1
	fi
	echo $1 done!
}
cd $package
function binutils(){
	prebuild binutils-2.29
	cd binutils-2.29
	mkdir build && cd build
	../configure --prefix=$prefix --with-lib-path=$prefix/lib 
	mkdir -v $prefix/lib && ln -sv lib $prefix/lib64 
	build binutils-2.29
}

function gcc(){
	prebuild gcc-7.2.0
	cd gcc-7.2.0
	tar -xf $package/mpfr-3.1.5.tar.xz
	ln -sv mpfr-3.1.5 mpfr
	tar -xf $package/gmp-6.1.2.tar.xz
	ln -sv gmp-6.1.2 gmp
	tar -xf $package/mpc-1.0.3.tar.gz
	ln -sv mpc-1.0.3 mpc
	mkdir build && cd build
	../configure --prefix=$prefix --disable-multilib --disable-bootsrap
	build gcc-7.2.0
}

function tcl(){
	prebuild tcl-core8.6.7-src
	mkdir -p $package/tcl8.6.7/build && cd $package/tcl8.6.7/build
	echo `pwd`
	../unix/configure --prefix=$prefix
	build
	ln -sv $prefix/bin/tclsh8.6 $prefix/bin/tclsh
}
function ncurses(){
	prebuild ncurses-6.0
	mkdir build && cd build
	../configure --prefix=$prefix \
		--with-shared   \
		--without-debug \
		--without-ada   \
		--enable-widec  \
		--enable-overwrite
	build
}
function bison(){
	prebuild bison-3.0.4
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function bzip2(){
	prebuild bzip2-1.0.6
	echo `pwd`
	make PREFIX=$prefix install
	cd $package
}
function coreutils(){
	prebuild coreutils-8.27
	mkdir build && cd build
	../configure --prefix=$prefix --enable-install-program=hostname
	build
}
function diffutils(){
	prebuild diffutils-3.6
	mkdir build && cd build
	../configure --prefix=$prefix 
	build
}
function findutils(){
	prebuild find-4.6.0 
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function gawk(){
	prebuild gawk-4.1.4 
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function gettext(){
	prebuild gettext-0.19.8.1
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function grep(){
	prebuild grep-3.1
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function gzip(){
	prebuild gzip-1.8
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function m4(){
	prebuild m4-1.4.18
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function bmake(){
	prebuild make-4.2.1
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function perl(){
	prebuild perl-5.26.0
	sh Configure -des -Dprefix=$prefix 
	make && make install
}
function sed(){
	prebuild sed-4.4
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function btar(){
	prebuild tar-1.29
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function texinfo(){
	prebuild texinfo-6.4
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
binutils
gcc
tcl
ncurses
bison
bzip2
coreutils
diffutils
findutils
gawk
gettext
grep
gzip
m4
bmake
perl
sed
btar
texinfo




