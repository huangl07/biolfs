#!/usr/bin/env sh

cat > ~/.bash_profile << "EOF"
export prefix=$HOME/.env/
export package=$HOME/package/
export CFLAGS="-fPIC"
export LD_LIBRARY_PATH=$prefix/lib/:$prefix/lib64/:/lib/:/lib64/:/usr/lib/:/usr/lib64/
export LIBRARY_PATH=$prefix/lib/:$prefix/lib64/:/lib/:/lib64/:/usr/lib/:/usr/lib64/
export C_INCLUDE_PATH=$prefix/include/:/include/:/usr/include/
export CPLUS_INCLUDE_PATH=$prefix/include/:/include/:/usr/include/
export PATH=$prefix/bin:/bin:/usr/bin
source ~/.bashrc
EOF
rm -rf ~/.bashrc && touch ~/.bashrc
mkdir -p $HOME/tools
mkdir -p $HOME/package
cd $HOME/package/

source ~/.bash_profile
