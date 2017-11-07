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
