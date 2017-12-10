#!/usr/bin/env sh

cat > ~/.bash_profile << "EOF"
export prefix=$HOME/temp-build/
export package=$HOME/package/8.1-rc1/
export CFLAGS="-fPIC"
export LD_LIBRARY_PATH=$prefix/lib/:$prefix/lib64/
export LIBRARY_PATH=$prefix/lib/:$prefix/lib64/
export C_INCLUDE_PATH=$prefix/include/
export CPLUS_INCLUDE_PATH=$prefix/include/
export PATH=$prefix/bin:/bin:/usr/bin
source ~/.bashrc
EOF
rm -rf ~/.bashrc && touch ~/.bashrc
mkdir -p $HOME/tools
mkdir -p $HOME/package
cd $HOME/package/

source ~/.bash_profile
