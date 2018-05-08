#!/usr/bin/env bash
export prefix=$HOME/.env
export package=$HOME/package/lfs-packages-8.2/
export CFLAGS="-fPIC"
mkdir -p $prefix
mkdir -p $prefix/lib
ln -sv $prefix/lib $prefix/lib64
function build(){
	make -j4
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
function zlib(){
	prebuild zlib-1.2.11
	./configure --prefix=$prefix 
	build zlib-1.2.11
}
function readline(){
	prebuild readline-7.0
	echo `pwd`
	mkdir build1 && cd build1
	../configure --prefix=$prefix --disable-static
	make install
	cd $package
}
function m4(){
	prebuild m4-1.4.18
	mkdir build1 && cd build1
	../configure --prefix=$prefix
	build m4-1.4.18
}
function bc(){
	prebuild bc-1.07.1
	mkdir build1 && cd build1
	../configure --prefix=$prefix \
		--with-readline
	build bc-1.07.1
}
function binutils(){
	prebuild binutils-2.30
	mkdir build1 && cd build1
	../configure --prefix=$prefix \
		--enable-gold       \
		--enable-ld=default \
		--enable-plugins    \
		--enable-shared     \
		--disable-werror    \
		--enable-64-bit-bfd \
		 --with-system-zlib
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
	mkdir build1 && cd build1
	../configure --prefix=$prefix --disable-multilib --disable-bootsrap --with-system-zlib
	build gcc-7.3.0
	ln -sv $prefix/bin/gcc /$prefix/bin/cc
}
function bzip2(){
	prebuild bzip2-1.0.6
	make -f Makefile-libbz2_so
	make clean
	make PREFIX=$prefix CFLAGS=-fPIC install
	cd $package
}
function pkgconfig(){
	prebuild pkg-config-0.29.2
	mkdir build && cd build
	../configure --prefix=$prefix \
		--with-internal-glib \
		--disable-host-tool
	build
}
function attr(){
	prebuild attr-2.4.47.src
	cd $package/attr-2.4.47
	./configure --prefix=$prefix --disable-static
	make
    make install install-dev install-lib
	cd $package
}
function acl(){
	prebuild acl-2.2.52-src
	cd $package/acl-2.2.52
	./configure --prefix=$prefix --disable-static
	make
	make install install-dev install-lib
	cd $package
}
function ncurses(){
	prebuild ncurses-6.1
	mkdir build1 && cd build1
	../configure --prefix=$prefix \
		--with-shared   \
		--without-debug \
		--without-normal \
		--enable-widec  \
		--enable-pc-files
	build ncurses-6.1
}

function bsed(){
	prebuild sed-4.4
	mkdir build1 && cd build1
	../configure --prefix=$prefix 
	build sed
}
function bison(){
	prebuild bison-3.0.4
	mkdir build1 && cd build1
	../configure --prefix=$prefix
	build bison-3.0.4
}
function flex(){
	prebuild flex-2.6.4
	mkdir build1 && cd build1
	../configure --prefix=$prefix
	build flex-2.6.4
}
function libcap(){
	prebuild libcap-2.25
	make PREFIX=$prefix install
	build libcap
}

function grep(){
	prebuild grep-3.1
	mkdir build1 && cd build1
	../configure --prefix=$prefix
	build grep-3.1
}
function libtool(){
	prebuild libtool-2.4.6
	mkdir build1 && cd build1
	../configure --prefix=$prefix
	build libtool-2.4.6
}
function gdbm(){
	prebuild gdbm-1.14.1
	./configure --prefix=$prefix --disable-static --enable-lbgdbm-compat
	build gdbm-1.14.1
}
function expat(){
	prebuild expat-2.2.5
	mkdir build1 && cd build1
	../configure --prefix=$prefix \
		--disable-static 
	build expat
}
function perl(){
	export BUILD_ZLIB=False
	export BUILD_BZIP2=0
	prebuild perl-5.26.1
	./Configure -des -Dprefix=$prefix -Duseshrplib -Dusethreads 
	make && make install
	echo yes|cpan
	cp ~/.cpan/CPAN/MyConfig.pm ~/.cpan/CPAN/MyConfig.pm.backup
	less -S ~/.cpan/CPAN/MyConfig.pm.backup|sed 's/http\:\/\/www\.cpan\.org\//https\:\/\/mirrors\.aliyun\.com\/CPAN\//g'|less -S > ~/.cpan/CPAN/Myconfig.pm
	unset BUILD_ZLIB BUILD_BZIP2
	cpan XML::Parser-2.44
}
function autoconf(){
	prebuild autoconf-2.69
	mkdir build1 && cd build1
	../configure --prefix=$prefix 
	build autoconf-2.69
}
function automake(){
	prebuild automake-1.15.1
	mkdir build1 && cd build1
	../configure --prefix=$prefix 
	build automake-1.15.1
}
function xz(){
	prebuild xz-5.2.3
	mkdir build1 && cd build1
	../configure --prefix=$prefix --disable-static
	build xz-5.2.3
}
function gettext(){
	prebuild gettext-0.19.8.1
	mkdir build1 && cd build1
	../configure --prefix=$prefix --disable-static
	build gettext-0.19.8.1
}
function libffi(){
	prebuild libffi-3.2.1
	mkdir build1 && cd build1
	../configure --prefix=$prefix --disable-static
	build libffi-3.2.1
}
function python(){
	prebuild Python-3.6.4
	./configure --prefix=$prefix --enable-shared --with-system-expat --with-system-ffi --with-ensurepip=yes 
	build python-3.6.4
	mkdir $HOME/.pip/;
}
function coreutils(){
	prebuild coreutils-8.29
	mkdir build1 && cd build1
	../configure --prefix=$prefix --enable-no-install-program=kill,uptime
	build
}
function diffutils(){
	prebuild diffutils-3.6
	mkdir build1 && cd build1
	../configure --prefix=$prefix 
	build diffutils-3.6
}
function findutils(){
	prebuild findutils-4.6.0 
	mkdir build1 && cd build1
	../configure --prefix=$prefix
	build find-4.6.0 
}
function gawk(){
	prebuild gawk-4.2.0 
	mkdir build1 && cd build1
	../configure --prefix=$prefix
	build gawk-4.2.0
}

function bless(){
	prebuild less-530
	mkdir build1 && cd build1
	../configure --prefix=$prefix
	build less-530
}
function gzip(){
	prebuild gzip-1.9
	mkdir build && cd build
	../configure --prefix=$prefix
	build gzip-1.9
}
function libpipeline(){
	prebuild libpipeline-1.5.0
	mkdir build && cd build
	../configure --prefix=$prefix
	build libpipeline-1.5.0
}
function bmake(){
	prebuild make-4.2.1
	mkdir build && cd build
	../configure --prefix=$prefix
	build make-4.2.1
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

function vim(){
	prebuild vim-8.0.586
	cd $package/vim80
	./configure --prefix=$prefix \
		--with-tlib=ncursesw
	build vim-8.0.586
}
#zlib
#readline
#m4
#bc
#binutils
#gcc
#bzip2
#pkgconfig
#ncurses
#attr
#acl
#libcap
#bsed
#bison
#flex
#grep
#libtool
#gdbm
#expat
#perl
#autoconf
#automake
#xz
#gettext
#libffi
#python
#coreutils
#diffutils
#gawk
#findutils
#bless
#gzip
#libpipeline
#bmake
#btar
#texinfo
#vim
