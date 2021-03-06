#!/usr/bin/env sh
mkdir -p $HOME/
wget http://mirrors.ustc.edu.cn/lfs/lfs-packages/lfs-packages-8.2.tar -P $HOME/
pushd $HOME/biolfs
popd

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
PATH=$HOME/tools/bin:/bin:/usr/bin
package=$HOME/package/
prefix=$HOME/tools/
export PATH
EOF
mkdir -p $HOME/tools
mkdir -p $HOME/package
cd $HOME/package/
tar -xvf $HOME/lfs-packages-8.2.tar
cd ~/
source ~/.bash_profile
