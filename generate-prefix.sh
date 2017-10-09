cd $HOME
wget http://mirrors.ustc.edu.cn/lfs/lfs-packages/lfs-packages-8.1-rc2.tar
tar -xvf lfs-packages-8.1-rc2.tar
cat > $HOME/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
cat > $HOME/.bashrc << "EOF"
export prefix=$HOME/prefix
export env=$HOME/.env/
export package=$HOME/8.1-rc1
umask 022
export PATH=$prefix/bin:/bin:/usr/bin
export CFLAGS="-fPIC"
EOF
source ~/.bash_profile
source ~/.bash_rc
mkdir $prefix
mkdir $env
cd 8.1-rc1
tar -xvf binutils-2.29.tar.bz2
mkdir binutils-build1
cd binutils-build1
../binutils-2.29/configure --prefix=$prefix && make -j8 && make install
cd $packages
tar -xvf gcc-7.2.0.tar.xz
mkdir gcc-build1
cd gcc-7.2.0
./contrib/download_prerequisites
cd ../gcc-build1
../gcc-7.2.0/configure --prefix=$prefix --disable-multilib  --disable-bootstrap && make -j8 && make install
ln -sv $prefix/bin/gcc $prefix/bin/cc
cd $package
tar -xvf tcl-core8.6.7-src.tar.gz
mkdir tcl-build1 && cd tcl-build1
../tcl8.6.7/unix/configure --prefix=$prefix && make -j8 && make install
ln -sv $prefix/bin/tclsh8.6 $prefix/bin/tclsh
cd $package
tar -xvf ncurses-6.0.tar.gz
mkdir ncurses-build1 && cd ncurses-build1
../ncurses-6.0/configure --prefix=$prefix --with-shared --without-ada --enable-widec --enable-overwrite && make -j8 && make install
cd $package
tar -xvf bzip2-1.0.6.tar.gz
cd bzip2-1.0.6 && make &&make PREFIX=$prefix install 
cd $package
tar -xvf coreutils-8.27.tar.gz
mkdir coreutils-build1 && cd coreutils-build1
../coreutils-8.27/configure --prefix=$prefix --enable-install-program=hostname && make -j8 && make install
cd $package
tar -xvf diffutils-3.6.tar.xz
mkdir diffutils-build1 && cd diffutils-build1
../diffutils-3.6/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf findutils-4.6.0.tar.gz
mkdir findutils-build1 && cd findutils-build1
../findutils-4.6.0/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf gawk-4.1.4.tar.xz
mkdir gawk-build1 && cd gawk-build1
../gawk-4.1.4/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf gettext-0.19.8.1.tar.xz
mkdir gettext-build1 && cd gettext-build1
../getext-0.19.8.1/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf grep-3.1.tar.xz
mkdir grep-build1 && cd grep-build1
../grep-3.1/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf gzip-1.8.tar.xz
mkdir gzip-build1 && cd gzip-build1
../gzip-1.8/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf m4-1.4.18.tar.xz
mkdir m4-build1 && cd m4-build1
../m4-1.4.18/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf make-4.2.1.tar.bz2
mkdir make-build1 && cd make-build1
../make-4.2.1/configure --prefix=$prefix --without-guile && make -j8 && make install
cd $package
tar -xvf perl-5.26.0.tar.xz
cd perl-5.26.0
./Configure -Dprefix=$prefix -des && make -j8 && make install
cd $package
tar -xvf sed-4.4.tar.xz
mkdir sed-build && cd sed-build
../sed-4.4/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf tar-1.29.tar.xz
mkdir tar-build && cd tar-build
../tar-1.29/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf texinfo-6.4.tar.xz
mkdir texinfo-build && cd texinfo-build
../texinfo-6.4/configure --prefix=$prefix && make -j8 && make install
cd $package
tar -xvf xz-5.2.3.tar.xz
mkdir xz-build && cd xz-build
../xz-5.2.3/configure --prefix=$prefix && make -j8 && make install
