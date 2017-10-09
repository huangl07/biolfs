source $HOME/.bashrc
echo "haha"
cat > $HOME/.bash_profile << "EOF"                   
export env=$HOME/.env/
export packages=$HOME/8.1-rc1/
export PATH=$env/bin/:$prefix/bin/:/usr/bin/:/bin
export LD_LIBRARY_PATH=$env/lib/:$env/lib64/   
export LIBRARY_PATH=$env/lib/:$env/lib64/
export C_INCLUDE_PATH=$env/include/
export CPLUS_INCLUDE_PATH=$env/include/
EOF
source $HOME/.bash_profile
source $HOME/.bashrc
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
cd $packages




