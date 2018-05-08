#!/usr/bin/env sh

cat > ~/.bash_profile << "EOF"
export prefix=$HOME/tools/
export package=$HOME/package/lfs-packages-8.2/
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
cd $HOME/package/

source ~/.bash_profile
