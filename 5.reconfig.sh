#!/usr/bin/env sh
cat > ~/.bash_profile << "EOF"
export prefix=$HOME/.env/
export package=$HOME/package/
export CFLAGS="-fPIC"
export LD_LIBRARY_PATH=$prefix/lib/:$prefix/lib64/:/lib/:/lib64/:/usr/lib/:/usr/lib64/
export LIBRARY_PATH=$prefix/lib/:$prefix/lib64/:/lib/:/lib64/:/usr/lib/:/usr/lib64/
export C_INCLUDE_PATH=$prefix/include/
export CPLUS_INCLUDE_PATH=$prefix/include/
export PATH=$prefix/bin:/bin:/usr/bin
export CXX=$prefix/bin/c++
source ~/.bashrc
EOF
rm -rf ~/.bashrc && touch ~/.bashrc
cat >~/.bashrc << "EOF"
alias qq='lfs quota /mnt/ilustre/ -h'
alias qu='qstat -u long.huang'
alias ll="ls -hl"
alias vi="vim -X"
alias vim="vim -X"
red='\e[01;31m'
cyan='\e[01;36m'
blue='\e[01;34m'
yellow='\e[01;33m'
purple='\e[01;35m'
green='\e[01;32m'
white='\e[01;37m'
PS1="$red\u $yellow: $green\h $yellow: $blue\t $yellow: $purple\d $yellow: $cyan\w $white\n$\[\e[0m\]"
EOF
cat >$HOME/.pip/pip.conf << "EOF"
[global]
trusted-host=mirrors.aliyun.com
index-url=https://mirrors.aliyun.com/pypi/simple
EOF
mkdir -p $HOME/tools
mkdir -p $HOME/package
cd $HOME/package/
cat > ~/.vimrc << "EOF"
set nocompatible            " 关闭 vi 兼容模式  
syntax on                   " 自动语法高亮  
set background=dark
set number                  " 显示行号  
set cursorline              " 突出显示当前行  
set ruler                   " 打开状态栏标尺  
set shiftwidth=4            " 设定 << 和 >> 命令移动时的宽度为 4  
set softtabstop=4           " 使得按退格键时可以一次删掉 4 个空格  
set tabstop=4               " 设定 tab 长度为 4  
set nobackup                " 覆盖文件时不备份  
set autochdir               " 自动切换当前目录为当前文件所在的目录  
filetype plugin indent on   " 开启插件  
set backupcopy=yes          " 设置备份时的行为为覆盖  
set ignorecase smartcase    " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感  
set nowrapscan              " 禁止在搜索到文件两端时重新搜索  
set incsearch               " 输入搜索内容时就显示搜索结果  
set hlsearch                " 搜索时高亮显示被找到的文本  
set noerrorbells            " 关闭错误信息响铃  
set novisualbell            " 关闭使用可视响铃代替呼叫  
set t_vb=                   " 置空错误铃声的终端代码  
set showmatch               " 插入括号时，短暂地跳转到匹配的对应括号  
set matchtime=2             " 短暂跳转到匹配括号的时间  
set magic                   " 设置魔术  
set hidden                  " 允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存  
set guioptions-=T           " 隐藏工具栏  
set guioptions-=m           " 隐藏菜单栏  
set smartindent             " 开启新行时使用智能自动缩进  
set backspace=indent,eol,start              " 不设定在插入状态无法用退格键和 Delete 键删除回车符  
set cmdheight=1             " 设定命令行的行数为 1  
set laststatus=2            " 显示状态栏 (默认值为 1, 无法显示状态栏)  
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\   " 设置在状态行显示的信息  
EOF


source ~/.bash_profile
