#!/usr/bin/env bash
export prefix=$HOME/tools/
export package=$HOME/package/lfs-packages-8.2/
export CFLAGS="-fPIC"
export PATH=$prefix/bin/:$PATH
function build(){
	make -j8
	make install
	cd $package
	echo $1," complete!"
}
function prebuild(){
	if [ -d $1 ]; then
		rm -rf $1
	fi
	tar -xvf $1.tar.*
	if [ -d $1/build1 ]; then
		echo "$1/build1"
		rm -rf $1/build1
	fi
	if [ -d $1/build ]; then
		rm -rf $1/build
	fi
	cd $1
	echo $1 done!
}
cd $package
function binutils(){
	prebuild binutils-2.30
	cd binutils-2.30
	mkdir build && cd build
	../configure --prefix=$prefix --with-lib-path=$prefix/lib 
	mkdir -v $prefix/lib && ln -sv lib $prefix/lib64 
	build binutils-2.30
}

function gcc(){
	prebuild gcc-7.3.0
	cd gcc-7.3.0
	tar -xf $package/mpfr-4.0.1.tar.xz
	ln -sv mpfr-4.0.1 mpfr
	tar -xf $package/gmp-6.1.2.tar.xz
	ln -sv gmp-6.1.2 gmp
	tar -xf $package/mpc-1.1.0.tar.gz
	ln -sv mpc-1.1.0 mpc
	mkdir build && cd build
	../configure --prefix=$prefix --disable-multilib --disable-bootsrap
	build gcc-7.3.0
	ln -s $prefix/bin/gcc $prefix/bin/cc
}

function tcl(){
	prebuild tcl8.6.8-src
	mkdir -p $package/tcl8.6.8/build && cd $package/tcl8.6.8/build
	../unix/configure --prefix=$prefix
	build tcl8.6.8
	ln -s $prefix/bin/tclsh8.6 $prefix/bin/tclsh
}
function expact(){
	prebuild expact-5.45.4
	mkdir build && cd build
	../configure --prefix=$prefix \
	--with-tcl=$prefix/lib \
	--with-tclinclude=$prefix/include
	build expact-5.45.4
}
function dejagnu(){
	prebuild dejagnu-1.6.1
	mkdir build && cd build
	../configure --prefix=$prefix \
	build dejagnu-1.6.1
}
function bbash(){
	prebuild bash-4.4.18
	mkdir build && cd build
	../configure --prefix=$prefix \
		--without-bash-malloc
	build bash-4.4.18
}


function ncurses(){
	prebuild ncurses-6.1
	mkdir build && cd build
	../configure --prefix=$prefix \
		--with-shared   \
		--without-debug \
		--without-ada   \
		--enable-widec  \
		--enable-overwrite
	build ncurses-6.1
}
function bison(){
	prebuild bison-3.0.4
	mkdir build && cd build
	../configure --prefix=$prefix
	build bison-3.0.4
}
function bzip2(){
	prebuild bzip2-1.0.6
	echo `pwd`
	make PREFIX=$prefix install
	cd $package
}
function coreutils(){
	prebuild coreutils-8.29
	mkdir build && cd build
	../configure --prefix=$prefix --enable-install-program=hostname
	build coreutils-8.29
}
function diffutils(){
	prebuild diffutils-3.6
	mkdir build && cd build
	../configure --prefix=$prefix 
	build diffutils-3.6
}
function findutils(){
	prebuild findutils-4.6.0 
	mkdir build && cd build
	../configure --prefix=$prefix
	build findutils-4.6.0
}
function gawk(){
	prebuild gawk-4.2.0 
	mkdir build && cd build
	../configure --prefix=$prefix
	build gawk-4.2.0 
}
function gettext(){
	prebuild gettext-0.19.8.1
	mkdir build && cd build
	../configure --prefix=$prefix --disable-shared
	make -C gnulib-lib
	make -C intl pluralx.c
	make -C src msgfmt
	make -C src msgmerge
	make -C src xgettext
	build gettext-0.19.8.1
}
function grep(){
	prebuild grep-3.1
	mkdir build && cd build
	../configure --prefix=$prefix
	build grep-3.1
}
function gzip(){
	prebuild gzip-1.9
	mkdir build && cd build
	../configure --prefix=$prefix
	build gzip-1.9
}
function m4(){
	prebuild m4-1.4.18
	mkdir build && cd build
	../configure --prefix=$prefix
	build m4-1.4.18
}
function bmake(){
	prebuild make-4.2.1
	mkdir build && cd build
	../configure --prefix=$prefix
	build make-4.2.1
}
function perl(){
	prebuild perl-5.26.1
	sh Configure -des -Dprefix=$prefix -Dlibs="-lm -pthread"
	make && make install
	cd $package
}
function sed(){
	prebuild sed-4.4
	mkdir build && cd build
	../configure --prefix=$prefix
	build sed-4.4
}
function btar(){
	prebuild tar-1.30
	mkdir build && cd build
	../configure --prefix=$prefix
	build tar-1.30
}
function texinfo(){
	prebuild texinfo-6.5
	mkdir build && cd build
	../configure --prefix=$prefix
	build texinfo-6.5
}
function xz(){
	prebuild xz-5.2.3
	mkdir build && cd build
	../configure --prefix=$prefix
	build xz-5.2.3
}
function patch(){
	prebuild patch-2.7.6
	mkdir build && cd build
	../configure --prefix=$prefix
	build patch-2.7.6
}


binutils
gcc
tcl
expect
dejagnu
m4
ncurses
bbash
bison
bzip2
coreutils
diffutils
findutils
gawk
gettext
grep
gzip
bmake
perl
sed
btar
texinfo
xz
