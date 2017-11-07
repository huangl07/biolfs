cat > $HOME/.bash_profile << "EOF"                   
export env=$HOME/.env/
export packages=$HOME/8.1-rc1/
export PATH=$env/bin/:$prefix/bin/:/usr/bin/:/bin
export LD_LIBRARY_PATH=$env/lib/:$env/lib64/   
export LIBRARY_PATH=$env/lib/:$env/lib64/
export C_INCLUDE_PATH=$env/include/
export CPLUS_INCLUDE_PATH=$env/include/
export PKG_CONFIG_PATH=$env/lib/pkgconfig:$env/lib64/pkgconfig
EOF
source $HOME/.bash_profile
source $HOME/.bashrc
mkdir -p $env
cd $packages
tar -xvf man-pages-4.12.tar.xz
cd man-pages-4.12
make PREFIX=$env install
cd $packages
tar -xvf zlib-1.2.11.tar.xz
cd zlib-1.2.11
./configure --prefix=$env && make -j8 && make install 
cd $packages
tar -xvf binutils-2.29.tar.bz2
mkdir binutils-build2 && cd binutils-build2
../binutils-2.29/configure --prefix=$env --enable-shared && make -j8 && make install
cd $packages
mkdir gcc-build2 && cd gcc-build2
../gcc-7.2.0/configure --prefix=$env --disable-multilib --disable-bootstrap && make -j8 && make install
ln -sv $env/bin/gcc $env/bin/cc
cd $packages/bzip2-1.0.6
make -f Makefile-libbz2_so && make clean && make && make PREFIX=$env install && cp -av libbz2.so* $env/lib/
cd $packages
tar -xvf pkg-config-0.29.2.tar.gz
cd pkg-config-0.29.2
./configure --prefix=$env --with-internal-glib && make -j8 && make install
mkdir $packages/ncurse-build2 && cd $packages/ncurse-build2
../ncurses-6.0/configure --prefix=$env --with-shared --enable-pc-files --enable-widec
make -j8 && make install
cd $env/lib/
for lib in ncurses form panel menu ; do ln -sfv lib${lib}w.a lib$lib.a;done
mkdir $packages/sed-build2 && cd $packages/sed-build2
../sed-4.4/configure --prefix=$env && make -j8 && make install
cd $package
mkdir coreutils-build2 && cd coreutils-build2
../coreutils-8.27/configure --prefix=$env && make -j8 && make install
cd $package
mkdir m4-build2 && cd m4-build2
../m4-1.4.18/configure --prefix=$env && make -j8 && make install
cd $package
tar -xvf flex-2.6.4.tar.gz
mkdir flex-build && cd flex-build
../flex-2.6.4/configure --prefix=$env && make -j8 && make install
ln -s $env/bin/flex $env/bin/lex
cd $package
tar -xvf bison-3.0.4.tar.xz
mkdir bison-build && cd bison-build
../bison-3.0.4/configure --prefix=$env && make -j8 && make install
cd $package
mkdir grep-build2 && cd grep-build2
../grep-3.1/configure --prefix=$env && make -j8 && make install
cd $package
tar -xvf readline-7.0.tar.gz
mkdir readline-build && cd readline-build
../readline-7.0/configure --prefix=$env && make SHLIB_LIBS=-lncurses -j8 && make install
tar -xvf bc-1.07.1.tar.gz
mkdir bc-build && cd bc-build
../bc-1.07.1/configure --prefix=$env --with-readline  && make -j8 && make install 
cd $package
tar -xvf libtool-2.4.6.tar.xz
mkdir libtool-build && cd libtool-build
../libtool-2.4.6/configure --prefix=$env && make -j8 && make install
cd $package
tar -xvf gdbm-1.13.tar.gz
mkdir gdbm-build && cd gdbm-build
../gdbm-1.13/configure --prefix=$env --enable-libgdbm-compat && make -j8 && make install
cd $package
tar -xvf expat-2.2.3.tar.bz2
mkdir expat-build && cd expat-build
../expat-2.2.3/configure --prefix=$env && make -j8 && make install
cd $package/perl-5.26.0 && make distclean 
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des -Dprefix=$env -Duseshrplib -Dusethreads && make -j8 && make install && unset BUILD_ZLIB BUILD_BZIP2
cd $package/
tar -xvf autoconf-2.6.9.tar.xz
mkdir autoconf-build && cd autoconf-build
./configure --prefix=$env
make -j8
make install
cd $package
tar -xvf automake-1.15.1.tar.xz
mkdir automake-build && cd automake
./configure --prefix=$env
make -j8
make install
cd $package/xz-5.2.3
mkdir xz-build2 && cd xz-build2
../configure --prefix=$env
make -j8
make install
cd $package


