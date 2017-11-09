#!/bin/bash

# ./6-build.sh [TASK]

# For each package:
# Using the tar program, extract the package to be built. In Chapter 5, ensure you are the lfs user when extracting the package.
# Change to the directory created when the package was extracted.
# Follow the book's instructions for building the package.
# Change back to the sources directory.
# Delete the extracted source directory and any <package>-build directories that were created in the build process unless instructed otherwise.

#tar: tar -xvf
#tar.gz: tar -zxvf 
#tar.bz2: tar -jxvf
#tar.xz: tar -Jxvf

SBU=30           # 30 seconds = 1 sbu when using -j 6 on my system
export MAKEFLAGS="-j 8"
runtests=0


    
f_off="\e[0m" 
f_bold="\e[1m"
f_orange="\e[38;5;202m"   
f_cyan="\e[38;5;75m"
f_green="\e[38;5;82m"


make-check(){
    if [ $runtests -eq 1 ]; then
        make check
    fi
}

generic-install(){
    ./configure --prefix=$prefix
    make
    make-check
    make install
}

countdown(){
    local title=$1
    
    local f_off="\e[0m" 
    local f_bold="\e[1m"
    local f_orange="\e[38;5;202m"   
    local f_cyan="\e[38;5;75m"
    local f_green="\e[38;5;82m"
    
    echo -e "${f_cyan}${f_bold}${title}${f_off}\n============"
    echo -e "${f_orange}${f_bold}3${f_off}"
    sleep 1
    echo -e "${f_cyan}${f_bold}2${f_off}"
    sleep 1
    echo -e "${f_green}${f_bold}1${f_off}"
    sleep 1    
}

sbu(){    
    local f_off="\e[0m"
    local f_orange="\e[38;5;202m"    
    local duration=$(php -r "echo $SBU * $1;")
    local minutes=$(php -r "echo round($duration / 60, 1);")
    echo -e "${f_orange}This part will take up around $1 SBU = $duration seconds ($minutes minutes) ${f_off}"
}

pre-build(){
    local f_off="\e[0m"
    local f_bold="\e[1m"
    local f_cyan="\e[38;5;75m"
    local pkg=$1
    local tartype=$2
    local sbu=$3
    local diroveride=$4

    clear
    echo -e "${f_cyan}${f_bold} $pkg ${f_off}"
    sbu $sbu
    countdown "Starting in.."
    
    cd $LFS/sources
    
    case $tartype in
        gz) tar -zxvf $pkg.tar.$tartype;;
        bz2) tar -jxvf $pkg.tar.$tartype;;
        xz) tar -Jxvf $pkg.tar.$tartype;;
    esac
    
    if [ -z ${diroveride} ]; then 
        echo -e "${f_cyan}\e[1m CD PKG: $pkg ${f_off}"
        cd $pkg
    else 
        echo -e "${f_cyan}\e[1m CD DIROVERIDE: $diroveride ${f_off}"
        cd $diroveride
    fi
    
}

post-build(){
    local f_off="\e[0m"
    local f_green="\e[38;5;82m"
    local f_cyan="\e[38;5;75m"
    local pkg=$1
    local diroveride=$2
    cd $LFS/sources
 
    if [ -z ${diroveride} ]; then
        rm -rf $pkg
    else 
        rm -rf $diroveride
    fi


    echo -e "${f_green}completed: $pkg ${f_off}"
    echo -e "${f_cyan}${f_bold} ${f_off}"

    countdown "Waiting a bit"
    countdown "Waiting again.."
}

clean-tools(){
    rm -rf $LFS$prefix/*
}

c-check(){
    local currdir=$(pwd)
    echo -e "${f_green}${f_bold}SANITY CHECK!${f_off}\n==========\nShould output something like: [Requesting program interpreter: $prefix/lib/ld-linux.so.2]\n==============="

    cd ~/
    echo 'main(){}' > dummy.c
    $LFS_TGT-gcc dummy.c
    readelf -l a.out | grep ': $prefix'
    echo "================================"
    rm -v dummy.c a.out
    cd ${currdir}
    echo -e "${f_bold}End of sanity check${f_off}"
    countdown "Waiting a bit"
}

lfs-own(){
    sudo chown -R lfs:lfs $LFS
}

root-own(){
    sudo chown -R root:root $LFS
}


54-binutils(){
    pre-build binutils-2.29 bz2 1
    
    mkdir -v ../binutils-build
    cd ../binutils-build
    #time { ../binutils-2.24/configure --prefix=$prefix --with-sysroot=$LFS --with-lib-path=$prefix/lib --target=$LFS_TGT --disable-nls --disable-werror && make && mkdir -v $prefix/lib && ln -sv lib $prefix/lib64 && make install; }
    
    ../binutils-2.24/configure     \
        --prefix=$prefix            \
        --target=$LFS_TGT          \
        --disable-nls              \
        --disable-werror
        
    make
    case $(uname -m) in
        x86_64) mkdir -v $prefix/lib && ln -sv lib $prefix/lib64 ;;
    esac
    make install

    rm -rf $LFS/sources/binutils-build
    # --prefix=$prefix: #This tells the configure script to prepare to install the Binutils programs in the $prefix directory.
    # --with-sysroot=$LFS: For cross compilation, this tells the build system to look in $LFS for the target system libraries as needed.
    # --with-lib-path=$prefix/lib: This specifies which library path the linker should be configured to use.
    # --target=$LFS_TGT: Because the machine description in the LFS_TGT variable is slightly different than the value returned by the config.guess script, this switch will tell the configure script to adjust Binutil's build system for building a cross linker.
    # --disable-nls: This disables internationalization as i18n is not needed for the temporary tools.
    # --disable-werror: This prevents the build from stopping in the event that there are warnings from the host's compiler.
    post-build binutils-2.24
}

55-gcc(){
    pre-build gcc-7.2.0 xz 7.2
    tar -xf ../mpfr-3.1.5.tar.xz
    mv -v mpfr-3.1.5 mpfr
    tar -xf ../gmp-6.1.2.tar.xz
    mv -v gmp-6.1.2 gmp
    tar -xf ../mpc-1.0.3.tar.gz
    mv -v mpc-1.0.3 mpc
    
    #The following command will change the location of GCC's default dynamic linker to use the one installed in $prefix. It also removes /usr/include from GCC's include search path. Issue:
for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@$prefix&@g' \
      -e 's@/usr@$prefix@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "$prefix/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

    #GCC doesn't detect stack protection correctly, which causes problems for the build of Glibc-2.20, so fix that by issuing the following command:
    sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

    #Also fix a problem identified upstream:
    sed -i 's/if \((code.*))\)/if (\1 \&\& \!DEBUG_INSN_P (insn))/' gcc/sched-deps.c

    mkdir -v ../gcc-build
    cd ../gcc-build
    ../gcc-7.2.0/configure                               \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

    make
    make install

    rm -rf $LFS/sources/gcc-build
    post-build gcc-7.2.0
}


build-54-to-57(){
    54-binutils
    sleep 1
    55-gcc
    sleep 1
}


59-binutils(){
    pre-build binutils-2.29 bz2 1.1
    mkdir -v ../binutils-build
    cd ../binutils-build
    CC=$LFS_TGT-gcc                \
    AR=$LFS_TGT-ar                 \
    RANLIB=$LFS_TGT-ranlib         \
    ../binutils-2.29/configure     \
        --prefix=$prefix            \
        --disable-nls              \
        --disable-werror           \
        --with-lib-path=$prefix/lib \
        --with-sysroot
    make
    make install
    
    # Now prepare the linker for the “Re-adjusting” phase in the next chapter:
    make -C ld clean
    make -C ld LIB_PATH=/usr/lib:/lib
    cp -v ld/ld-new $prefix/bin

    rm -rf $LFS/sources/binutils-build
    post-build binutils-2.29
}

510-gcc(){
    pre-build gcc-7.2.0 xz 7.2
    
   cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
  
for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@$prefix&@g' \
      -e 's@/usr@$prefix@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "$prefix/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

tar -xf ../mpfr-3.1.5.tar.xz
mv -v mpfr-3.1.5 mpfr
tar -xf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc

sed -i 's/if \((code.*))\)/if (\1 \&\& \!DEBUG_INSN_P (insn))/' gcc/sched-deps.c

mkdir -v ../gcc-build
cd ../gcc-build

CC=$LFS_TGT-gcc                                      \
CXX=$LFS_TGT-g++                                     \
AR=$LFS_TGT-ar                                       \
RANLIB=$LFS_TGT-ranlib                               \
../gcc-7.2.0/configure                               \
    --prefix=$prefix                                  \
    --with-local-prefix=$prefix                       \
    --with-native-system-header-dir=$prefix/include   \
    --enable-languages=c,c++                         \
    --disable-multilib                               \
    --disable-bootstrap                              \
    --disable-libgomp
    
    make
    make install
    
    ln -sv gcc $prefix/bin/cc

    rm -rf $LFS/sources/gcc-build
    post-build gcc-7.2.0
    c-check  
}

build-58-to-510(){
    58-libstdc
    sleep 1
    59-binutils
    sleep 1
    510-gcc
}


511-tcl(){
    pre-build tcl-core8.6.7-src gz 1 tcl8.6.7
    
    cd unix
    ./configure --prefix=$prefix
    make

    # Run test suite
   # TZ=UTC make test
    
    # Then install
    make install

    # Make the installed library writable so debugging symbols can be removed later:
    chmod -v u+w $prefix/lib/libtcl8.6.so

    #Install Tcl's headers. The next package, Expect, requires them to build.
    make install-private-headers

    #Now make a necessary symbolic link:
    ln -sv tclsh8.6 $prefix/bin/tclsh
    
}

512-expect(){
    pre-build expect5.45 gz 0.1
    
    cp -v configure{,.orig}
    sed 's:/usr/local/bin:/bin:' configure.orig > configure
   
   
    ./configure --prefix=$prefix \
        --with-tcl=$prefix/lib \
        --with-tclinclude=$prefix/include
        
    make
  # make test
    make SCRIPTS="" install
            
    post-build expect5.45
}

513-dejagnu(){
    pre-build dejagnu-1.6 gz 0.1
    ./configure --prefix=$prefix
    make install
    make-check
    post-build dejagnu-1.6
}

514-check(){
    pre-build check-0.11.0 gz 1
    PKG_CONFIG= ./configure --prefix=$prefix
    make
    make-check
    make install
    post-build check-0.11.0
}

515-ncurses(){
    pre-build ncurses-6.0 gz 0.6
    
    ./configure --prefix=$prefix \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite
            
    make
    make install
    
    post-build ncurses-6.0
}

516-bash(){
    pre-build bash-4.4 gz 0.4
    
    ./configure --prefix=$prefix --without-bash-malloc
    make
    #make tests
    make install
    ln -sv bash  $prefix/bin/sh
    
    post-build bash-4.4
}
516.5-bison(){
	pre-build bison-3.0.4 xz bison
	./configure --prefix=$prefix
	make 
	make install
}
517-bzip2(){
    pre-build bzip2-1.0.6 gz 1
    make
    make PREFIX=$prefix install
    post-build bzip2-1.0.6
}

518-coreutils(){
    pre-build coreutils-8.27 xz 1
    ./configure --prefix=$prefix --enable-install-program=hostname
    make
    #make RUN_EXPENSIVE_TESTS=yes check
    make install
    post-build coreutils-8.27
}

build-511-to-518(){
    511-tcl
    sleep 1
    512-expect
    sleep 1
    513-dejagnu
    sleep 1
    514-check
    sleep 1
    515-ncurses
    sleep 1
    516-bash
    sleep 1
    517-bzip2
    sleep 1
    518-coreutils
}


519-diffutils(){
    pre-build diffutils-3.6 xz 1
    generic-install
    post-build diffutils-3.6
}


521-findutils(){
    pre-build findutils-4.6.0 gz 1
    generic-install    
    post-build findutils-4.6.0
}

522-gawk(){
    pre-build gawk-4.1.4 xz 1
    generic-install
    post-build gawk-4.1.4
}

523-gettext(){
    pre-build gettext-0.19.8 xz 1
    cd gettext-tools
    EMACS="no" ./configure --prefix=$prefix --disable-shared
    
    make -C gnulib-lib
    make -C src msgfmt
    make -C src msgmerge
    make -C src xgettext
    cp -v src/{msgfmt,msgmerge,xgettext} $prefix/bin
    
    post-build gettext-0.19.8
}

524-grep(){
    pre-build grep-3.1 xz 1
    generic-install    
    post-build grep-3.1
}

525-gzip(){
    pre-build gzip-1.8 xz 1
    generic-install
    post-build gzip-1.8
}

526-m4(){
    pre-build m4-1.4.18 xz 1
    generic-install
    post-build m4-1.4.18
}

527-make(){
    pre-build make-4.2.1 bz2 1
    ./configure --prefix=$prefix --without-guile
    make
    make-check
    make install
    post-build make-4.2.1
}

528-patch(){
    pre-build patch-2.7.5 xz 1
    generic-install
    post-build patch-2.7.5
}

529-perl(){
    pre-build perl-5.26.0 bz2 1
    sh Configure -des -Dprefix=$prefix -Dlibs=-lm 
    make
    cp -v perl cpan/podlators/pod2man $prefix/bin
    mkdir -pv $prefix/lib/perl5/5.20.0
    cp -Rv lib/* $prefix/lib/perl5/5.20.0
    post-build perl-5.26.0
}

530-sed(){
    pre-build sed-4.4 bz2 0.1
    generic-install
    post-build sed-4.4
}

531-tar(){
    pre-build tar-1.289 xz 1
    generic-install
    post-build tar-1.29
}

532-texinfo(){
    pre-build texinfo-6.4 xz 1
    generic-install
    post-build texinfo-6.4
}

534-xz(){
    pre-build xz-5.2.3 xz 1
    generic-install
    post-build xz-5.2.3
}

build-519-to-534(){
    519-diffutils
    sleep 1
    521-findutils
    sleep 1
    522-gawk
    sleep 1
    523-gettext
    sleep 1
    524-grep
    sleep 1
    525-gzip
    sleep 1
    526-m4
    sleep 1
    527-make
    sleep 1
    528-patch
    sleep 1
    529-perl
    sleep 1
    530-sed
    sleep 1
    531-tar
    sleep 1
    532-texinfo
    sleep 1
    534-xz
}

    build-54-to-57
    build-58-to-510
    build-511-to-518
    build-519-to-534
    clean-tools

