#!/usr/bin/env sh
export prefix=$HOME/.env
export package=$HOME/package/lfs-packages-8.2/
export CFLAGS="-fPIC"
mkdir -p $prefix
function build(){
	make -j8
	make install
	cd $package
	echo $1," complete!"
}
function prebuild(){
	tar -xvf $1.tar.*
	if [ -d $1 ]; then 
		cd $1
	fi
	echo $1 done!
}
cd $package
function apr(){
	wget https://archive.apache.org/dist/apr/apr-1.6.3.tar.bz2
	prebuild apr-1.6.3
	./configure --prefix=$prefix --disable-static
	build apr-1.6.3
}
function apr-util(){
	wget https://archive.apache.org/dist/apr/apr-1.6.3.tar.bz2
	prebuild apr-1.6.3
	./configure --prefix=$prefix --disable-static
	build apr-1.6.3
}

