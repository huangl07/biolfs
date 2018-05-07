#!/usr/bin/env sh

cat > ~/.bash_profile << "EOF"
export prefix=$HOME/temp-build/
export package=$HOME/package/8.1-rc1/
export env=$HOME/.env/
export CFLAGS="-fPIC"
export LD_LIBRARY_PATH=$env/lib/:$env/lib64:$prefix/lib/:$prefix/lib64/
export LIBRARY_PATH=$env/lib/:$env/lib64:$prefix/lib/:$prefix/lib64/
export C_INCLUDE_PATH=$env/include/:$prefix/include/
export CPLUS_INCLUDE_PATH=$env/include/:$prefix/include/
export PATH=$env/bin/:$prefix/bin:/bin:/usr/bin
source ~/.bashrc
EOF
rm -rf ~/.bashrc && touch ~/.bashrc
mkdir -p $HOME/tools
mkdir -p $HOME/package
cd $HOME/package/

source ~/.bash_profile
