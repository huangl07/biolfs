
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
	if [ -d $1 ]; then
		rm -rf $1
	fi
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
	wget https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.bz2
	prebuild apr-util-1.6.1
	./configure --prefix=$prefix --disable-static --with-apr=$prefix
	build apr-1.6.3
}
function aspell(){
	wget https://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz
	prebuild aspell-0.60.6.1
	sed -i '/ top.do_check ==/s/top.do_check/*&/' modules/filter/tex.cpp
	sed -i '/word ==/s/word/*&/'                  prog/check_funs.cpp
	./configure --prefix=$prefix
	build aspell-0.60.6.1
}
function boost(){
	wget  https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.bz2
	prebuild boost_1_66_0
	./bootstrap.sh --prefix=$prefix 
	./b2 stage threading=multi link=shared
	./b2 install threading=multi link=shared
}
function clucene(){
	wget https://downloads.sourceforge.net/clucene/clucene-core-2.3.3.4.tar.gz
	prebuild clucene-core-2.3.3.4
	mkdir build && cd build
	cmake -DCMAKE_INSTALL_PREFIX=$prefix \
		 -DBUILD_CONTRIBS_LIB=0N ../ 
	build
}
function dbus-glib(){
	wget https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.110.tar.gz
	prebuild dbus-glib-0.110
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function enhance(){
	wget https://github.com/AbiWord/enchant/releases/download/v2.2.3/enchant-2.2.3.tar.gz
	prebuild enchant-2.2.3
	mkdir build && cd build
	../configure --prefix=$prefix --disable=static
	build
}
function exampi(){
	wget https://libopenraw.freedesktop.org/download/exempi-2.4.4.tar.bz2
	prebuild exempi-2.4.4
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function fftw(){
	wget http://www.fftw.org/fftw-3.3.7.tar.gz
	prebuild fftw-3.3.7
	mkdir build && cd build
	../configure --prefix=$prefix --enable-shared --enable-threads
	build
}
function glib(){
	wget http://ftp.gnome.org/pub/gnome/sources/glib/2.54/glib-2.54.3.tar.xz
	prebuild glib-2.54.3
	mkdir build && cd build
	meson  --prefix=$prefix ..
	ninja && ninja install
	cd $package
}	
function glibmm(){
	wget http://ftp.gnome.org/pub/gnome/sources/glibmm/2.54/glibmm-2.54.1.tar.xz
	prebuild glibmm-2.54.1
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function gmime(){
	wget http://ftp.gnome.org/pub/gnome/sources/gmime/2.6/gmime-2.6.23.tar.xz
	prebuild gmime-2.6.23
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}	
function gobject(){
	wget http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.54/gobject-introspection-1.54.1.tar.xz
	prebuild gobject-introspection-1.54.1
	mkdir build && cd build
	../configure --prefix=$prefix \
			--disable-static
	build
}
function grantlee(){
	wget http://downloads.grantlee.org/grantlee-5.1.0.tar.gz
	prebuild grantlee-5.1.0
	mkdir build && cd build
	cmake -DCMAKE_INSTALL_PREFIX=$prefix \
		      -DCMAKE_BUILD_TYPE=Release  ..\
	build
}
function gsl(){
	wget https://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz
	prebuild gsl-2.4
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function icu(){
	wget http://download.icu-project.org/files/icu4c/60.2/icu4c-60_2-src.tgz
	prebuild icu4c-60_2-src
	mkdir build && cd build 
	../configure --prefix=$prefix
	build
}
function js(){
	wget http://anduin.linuxfromscratch.org/BLFS/mozjs/mozjs-38.2.1.rc0.tar.bz2
	prebuild mozjs-38.2.1.rc0
	cd js/src
	autoconf2.13
	./configure --prefix=$prefix   --with-intl-api     \
		--with-system-zlib  \
		--with-system-ffi   \
		--with-system-nspr  \
		--with-system-icu   \
		--enable-threadsafe \
		--enable-readline
	build
}
function jsc(){
	wget  https://s3.amazonaws.com/json-c_releases/releases/json-c-0.13.tar.gz
	prebuild json-c-0.13
	mkdir build && cd build
	../configure --prefix=$prefix --disble-static
	build
}
function jsglib(){
	wget http://ftp.gnome.org/pub/gnome/sources/json-glib/1.4/json-glib-1.4.2.tar.xz
	prebuild json-glib-1.4.2
	mkdir build && cd build
	meson --prefix=$prefix ../
	ninja
	ninja install
	cd $package
}
function libarchive(){
	wget http://www.libarchive.org/downloads/libarchive-3.3.2.tar.gz
	prebuild libarchive-3.3.2
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libassuan(){
	wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.1.tar.bz2
	prebuild libassuan-2.5.1
	mkdir build && cd build
	../configure --prefix=$prefix 
	build
}
function libatasmart(){
	wget http://0pointer.de/public/libatasmart-0.19.tar.xz
	prebuild libatasmart-0.19
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libatomic(){
	wget https://github.com/ivmai/libatomic_ops/releases/download/v7.6.2/libatomic_ops-7.6.2.tar.gz
	prebuild libatomic_ops-7.6.2
	mkdir build && cd build
	../configure --prefix=$prefix  --enable-shared   --disable-static 
	build
}
function libblockdev(){
	wget https://github.com/storaged-project/libblockdev/releases/download/2.16-1/libblockdev-2.16.tar.gz
	prebuild libblockdev-2.16
	mkdir build && cd build
	../configure --prefix=$prefix --with-python3 
	build
}
function libbytesize(){
	wget https://github.com/storaged-project/libbytesize/releases/download/1.2/libbytesize-1.2.tar.gz
	prebuild libbytesize-1.2
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libcroco(){
	wget http://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/libcroco-0.6.12.tar.xz
	prebuild libcroco-0.6.12
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libdaemon(){
	wget http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz
	prebuild libdaemon-0.14
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libesmtp(){
	wget http://brianstafford.info/libesmtp/libesmtp-1.0.6.tar.bz2
	prebuild libesmtp-1.0.6
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libgcrypt(){
	wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.2.tar.bz2
	prebuild libgcrypt-1.8.2
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libgpgerror(){
	wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.27.tar.bz2
	prebuild libgpg-error-1.27
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libgsf(){
	wget http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/libgsf-1.14.42.tar.xz
	prebuild libgsf-1.14.42.tar.xz 
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libgudev(){
	wget http://ftp.gnome.org/pub/gnome/sources/libgudev/232/libgudev-232.tar.xz
	prebuild libgudev-232
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libgusb(){
	wget https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.0.tar.xz
	prebuild libgusb-0.3.0
	meson --prefix=$prefix
	ninja
	ninja install
}
function libical(){
	wget https://github.com/libical/libical/releases/download/v3.0.1/libical-3.0.1.tar.gz
	prebuild libical-3.0.1
	mkdir build && cd build
	cmake -DCMAKE_INSTALL_PREFIX=/usr      \
		  -DCMAKE_BUILD_TYPE=Release       \
		  -DSHARED_ONLY=yes                \
		  .. &&
	build				  
}
function libidn(){
	wget https://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz
	prebuild libidn-1.33
	mkdir build && cd build
	../configure --prefix=$prefix --diable-static
	build
}
function libidn2(){
	wget https://ftp.gnu.org/gnu/libidn/libidn2-2.0.4.tar.gz
	prebuild libind2-2.0.4
	mkdir build && cd build
	../configure --prefix=/usr --disable-static
	build
}
function libiodbc(){
	wget https://downloads.sourceforge.net/iodbc/libiodbc-3.52.12.tar.gz
	prebuild libiodbc-3.52.12
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libksba(){
	wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.3.5.tar.bz2
	prebuild libkasba-1.3.5
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libmbim(){
	wget https://www.freedesktop.org/software/libmbim/libmbim-1.16.0.tar.xz
	prebuild libmbim-1.16.0
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libpapper(){
	wget http://ftp.debian.org/debian/pool/main/libp/libpaper/libpaper_1.1.24+nmu5.tar.gz
	prebuild libpapper-1.1.24+nmu5
	autoconf -fi
	./configure --prefix=$prefix --disable-static
	build
}
function libqmi(){
	wget https://www.freedesktop.org/software/libqmi/libqmi-1.20.0.tar.xz
	prebuild libqmi-1.20.0
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libseccomp(){
	wget https://github.com/seccomp/libseccomp/releases/download/v2.3.3/libseccomp-2.3.3.tar.gz
	prebuild libseccomp-2.3.3
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libsigc(){
	wget http://ftp.gnome.org/pub/gnome/sources/libsigc++/2.10/libsigc++-2.10.0.tar.xz
	prebuild libsigc++-2.10.0
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function libsigsegv(){
	wget https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.12.tar.gz
	prebuild libsigsegv-2.12
	mkdir build && cd build
	../configure --prefix=$prefix --enable-shared --disable-static
	build
}
function libstatgrab(){
	wget http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz
	prebuild libstatgrab-0.91.tar.gz
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libtasn(){
	wget https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.13.tar.gz
	prebuild libtasn1-4.13
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libunique(){
	wget http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/libunique-1.1.6.tar.bz2
	prebuild libunique-1.1.6
	mkdir build && cd build
	../configure --prefix=$prefix --disable-dbus --disable-static
	build
}
function libunistring(){
	wget https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.8.tar.xz
	prebuild libunistring-0.9.8
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libusb(){
	wget https://github.com//libusb/libusb/releases/download/v1.0.21/libusb-1.0.21.tar.bz2
	prebuild libusb-1.0.21
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libusc-compat(){
	wget https://downloads.sourceforge.net/libusb/libusb-compat-0.1.5.tar.bz2
	prebuild libusb-compat-0.1.5
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libuv(){
	wget https://github.com/libuv/libuv/archive/v1.19.1/libuv-1.19.1.tar.gz
	prebuild libuv-1.19.1
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libxkbcommon(){
	wget https://xkbcommon.org/download/libxkbcommon-0.8.0.tar.xz
    prebuild libxkbcommon-0.8.0.tar.xz
	mkdir build && cd build
	../configure $KORG_CONFIG
	build	
} 
function libxml(){
	wget http://xmlsoft.org/sources/libxml2-2.9.7.tar.gz
	prebuild libxml2-2.9.7.tar.gz
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static --with-history
	build
}
function libxslt(){
	wget http://xmlsoft.org/sources/libxslt-1.1.32.tar.gz
	prebuild libxslt-1.1.32
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static 
	build
}
function lzo(){
	wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz
	prebuild lzo-2.10
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function mtdev(){
	wget http://bitmath.org/code/mtdev/mtdev-1.1.5.tar.bz2
	prebuild mtdev-1.1.5
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function nodejs(){
	wget https://nodejs.org/dist/v9.5.0/node-v9.5.0.tar.xz
	prebuild node-v9.5.0
	mkdir build && cd build
	../configure --prefix=$prefix --shared-cares --shared-openssl --shared-zlib --with-intl=system-icu
	build	
}
function npth(){
	wget https://www.gnupg.org/ftp/gcrypt/npth/npth-1.5.tar.bz2
	prebuild npth-1.5
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function nspr(){
	wget https://archive.mozilla.org/pub/nspr/releases/v4.18/src/nspr-4.18.tar.gz
	prebuild nspr-4.18
	mkdir build && cd build
	../configure --prefix=$prefix --with-mozilla --with-pthreads --enable-64bit
	build
}
function oepnobex(){
	wget https://downloads.sourceforge.net/openobex/openobex-1.7.2-Source.tar.gz
	prebuild openobex-1.7.2
	mkdir build && cd build
	cmake -DCMAKE_INSTALL_PREFIX=$prefix      \
		  -DCMAKE_BUILD_TYPE=Release       \
	      -Wno-dev                         
	build
}
function pcre(){
	wget https://downloads.sourceforge.net/pcre/pcre-8.41.tar.bz2
	prebuild pcre-8.41
	mkdir build && cd build
	../configure --prefix=$prefix \
		--enable-unicode-properties       \
		--enable-pcre16                   \
		--enable-pcre32                   \
		--enable-pcregrep-libz            \
		--enable-pcregrep-libbz2          \
		--enable-pcretest-libreadline     \
		--disable-static
	build
}
function pcre2(){
	wget https://downloads.sourceforge.net/pcre/pcre2-10.31.tar.bz2
	prebuild pcre2-10.31
	mkdir build && cd build
	../configure --prefix=$prefix \
		    --enable-unicode       \
		    --enable-pcre2-16                   \
		    --enable-pcre2-32                   \
		    --enable-pcre2grep-libz            \
		    --enable-pcre2grep-libbz2          \
		    --enable-pcre2test-libreadline     \
		    --disable-static
	build
}
function popt(){
	wget http://rpm5.org/files/popt/popt-1.16.tar.gz
	prebuild popt-1.16
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function pth(){
	wget https://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz
	prebuild pth-2.0.7
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function ptlib(){
	wget http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz
	prebuild ptlib-2.10.11
	mkdir build && cd build
	../configure --prefix=$prefix --disable-odbc
	build
}
function xapian(){
	wget http://oligarchy.co.uk/xapian/1.4.5/xapian-core-1.4.5.tar.xz
	prebuild xapian-core-1.4.5
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function wv(){
	wget http://www.abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz
	prebuild wv-1.2.9
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function wayland(){
	wget https://wayland.freedesktop.org/releases/wayland-1.14.0.tar.xz
	prebuild wayland-1.14.0
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function talloc(){
	wget https://www.samba.org/ftp/talloc/talloc-2.1.11.tar.gz
	prebuild talloc-2.1.11
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function waylandprot(){
	wget https://wayland.freedesktop.org/releases/wayland-protocols-1.13.tar.xz
	prebuld wayland-protocols-1.13.tar.xz
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function yaml(){
	wget http://pyyaml.org/download/libyaml/yaml-0.1.7.tar.gz
	prebuild yaml-0.1.7
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function aalib(){
	wget https://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz
	prebuild aalib-1.4rc5
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static 
	build
}
function babl(){
	wget https://download.gimp.org/pub/babl/0.1/babl-0.1.42.tar.bz2
	prebuild babl-0.1.42
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function exiv(){
	wget http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz
	prebuild exiv2-0.26-trunk
	mkdir build && cd build
	./configure --prefix=$prefix     \
	            --enable-video    \
	            --enable-webready \
	            --without-ssh     \
	            --disable-static  
	build
}
function freetype2(){
	wget https://downloads.sourceforge.net/freetype/freetype-2.9.tar.bz2
	prebuild freetype-2.9
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function frontconf(){
	wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.6.tar.bz2
	prebuild fontconfig-2.12.6
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function fribidi(){
	wget https://github.com/fribidi/fribidi/releases/download/v1.0.1/fribidi-1.0.1.tar.bz2
	prebuild fribidi-1.0.1
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function gegl(){
	wget https://download.gimp.org/pub/gegl/0.3/gegl-0.3.28.tar.bz2
	prebuild gegl-0.3.28
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function giflib(){
	wget https://downloads.sourceforge.net/giflib/giflib-5.1.4.tar.bz2
	prebuild giflib-5.1.4
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function graphite2(){
	wget https://github.com/silnrsi/graphite/releases/download/1.3.10/graphite2-1.3.10.tgz
	prebuild graphite2-1.3.10
	mkdir build && cd    build
	cmake -DCMAKE_INSTALL_PREFIX=$prefix .. 
	build
}
function harfbuzz(){
	wget https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.7.5.tar.bz2
	prebuild harfbuzz-1.7.5.tar.bz2
	mkdir build && cd build
	../configure --prefix=$prefix --with-gobject
	build
}
function ijs(){
	wget https://www.openprinting.org/download/ijs/download/ijs-0.35.tar.bz2
	prebuild ijs-0.35
	mkdir build && cd build
	../configure --prefix=$prefix --enable-shared --disable-static
	build
}
function jasper(){
	wget http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.14.tar.gz
	prebuild jasper-2.0.14
	mkdir build &&  cd build 
	cmake -DCMAKE_INSTALL_PREFIX=$prefix  -DCMAKE_BUILD_TYPE=Release  
	build
}
function lcms1(){
	wget https://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz
	prebuild lcms-1.19
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
    build	
}
function lcms2(){
	wget https://downloads.sourceforge.net/lcms/lcms2-2.9.tar.gz
	prebuild lcms2-2.9
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libexif(){
	wget https://downloads.sourceforge.net/libexif/libexif-0.6.21.tar.bz2
	prebuild libexif-0.6.21
	mkdir build &&  cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libjpeg(){
	wget https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.3.tar.gz
	prebuild libjpeg-turbo-1.5.3
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static --with-jpeg8
	build
}
function libmng(){
	wget https://downloads.sourceforge.net/libmng/libmng-2.0.3.tar.xz
	prebuild libmng-2.0.3
	mkdir build &&  cd build
	../configure --prefix=$prefix --disable-static
	build
}
function libpng(){
	wget https://downloads.sourceforge.net/libpng/libpng-1.6.34.tar.xz
	prebuild libpng-1.6.34
	mkdir build &&  cd build
	../configure --prefix=$prefix --disaple-statics
	build
}
function libraw(){
	wget http://www.libraw.org/data/LibRaw-0.18.7.tar.gz
	prebuild LibRaw-0.18.7
	mkdir build && cd build
	../configure --prefix=$prefix  --enable-jpeg    \
		            --enable-jasper  \
					            --enable-lcms    \
								            --disable-static 
	build
}
function librsvg(){
	wget http://ftp.gnome.org/pub/gnome/sources/librsvg/2.42/librsvg-2.42.2.tar.xz
	prebuild librsvg
	mkdir build && cd build
	../configure --prefix=$prefix --enable-vala --disable-static
	build
}
function libtiff(){
	wget http://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz
	prebuild tiff-4.0.9
	mkdir build && cd build
	cmake  -DCMAKE_INSTALL_PREFIX=$prefix -G Ninja .. 
	ninja
	ninja install
}
function libwebp(){
	wget http://downloads.webmproject.org/releases/webp/libwebp-0.6.1.tar.gz
	prebuild libwebp-0.6.1
	mkdir build && cd build
	../configure --prefix=$prefix --enable-libwebpmux     \
            --enable-libwebpdemux   \
            --enable-libwebpdecoder \
            --enable-libwebpextras  \
            --enable-swap-16bit-csp \
            --disable-static 
	build
}
function newt(){
	wget https://releases.pagure.org/newt/newt-0.52.20.tar.gz
	prebuild newt-0.52.20
	mkdir build &&  cd build
	../configure --prefix=$prefix  --with-gpm-support 
	build
}
function opencv(){
	wget https://downloads.sourceforge.net/opencvlibrary/opencv-3.4.0.zip
	prebuild opencv-3.4.0
	mkdir build &&  cd build
	cmake -DCMAKE_INSTALL_PREFIX=$prefix
    build	
}
function openjpeg(){
	wget https://downloads.sourceforge.net/openjpeg.mirror/openjpeg-1.5.2.tar.gz
	prebuild openjpeg-1.5.2
	autoreconf -f -i 
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function openjpeg2(){
	wget https://github.com/uclouvain/openjpeg/archive/v2.3.0/openjpeg-2.3.0.tar.gz
	prebuild openjpeg-2.3.0
	mkdir build && cd build
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$prefix .. 
	build
}
function pixman(){
	wget https://www.cairographics.org/releases/pixman-0.34.0.tar.gz
	prebuild pixman-0.34.0
	mkdir build && cd build
	../configure --prefix=$prefeix --disable-static
	build
}
function poppler(){
	wget https://poppler.freedesktop.org/poppler-0.62.0.tar.xz
	prebuild poppler-0.62.0
	mkdir build && cd build
	cmake -DCMAKE_BUILD_TYPE=Release   \
		       -DCMAKE_INSTALL_PREFIX=$prefix  
	build
}
function potrace(){
	wget https://downloads.sourceforge.net/potrace/potrace-1.15.tar.gz
	prebuild potrace-1.15
	mkdir build && cd build
	../configure --disable-static --prefix=$prefix --enable-a4 --enable-metric --with-libpotrace
	build
}
function qpdf(){
	wget https://downloads.sourceforge.net/qpdf/qpdf-7.1.1.tar.gz
	prebuild qpdf-7.1.1
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function asciidoc(){
	wget https://downloads.sourceforge.net/asciidoc/asciidoc-8.6.9.tar.gz
	prebuild assiidoc-8.6.9
	mkdir build && cd build
	../configure --prefix=$prefix 
	build
}
function chrpath(){
	wget https://alioth.debian.org/frs/download.php/latestfile/813/chrpath-0.16.tar.gz
	prebuild chrpath-0.16
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function compface(){
	wget http://anduin.linuxfromscratch.org/BLFS/compface/compface-1.5.2.tar.gz
	prebuild compface-1.5.2
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function graphviz(){
	wget http://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz
	prebuild graphviz
	mkdir build && cd build
	autoconf
	../configure --prefix=$prefix
	build
}
function imagemagick7(){
	wget https://www.imagemagick.org/download/releases/ImageMagick-7.0.7-23.tar.xz
	prebuild imagemagick-7.0.7-23
	mkdir build && cd build
	../configure --prefix=$prefix --enable-hdri --whith-modules -with-perl --disable-static
	build
}
function time(){
	wget https://ftp.gnu.org/gnu/time/time-1.8.tar.gz
	prebuild time-1.8
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function tree(){
	wget http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz
	tar -xvf tree-1.7.0.tgz
	cd tree-1.7.0
	make PREFIX=$prefix install
}
function bcmake(){
	wget https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz
	prebuild cmake-3.10.2
	./bootstrap --prefix=$prefix --system-libs
	build
}
function Python2.7(){
	wget https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tar.xz
	prebuild Python-2.7.14
	./configure --prefix=$prefix --enable-shared  --with-system-expat --with-system-ffi --with-ensurepip=yes --enable-unicode=ucs4 
	build
}
function php(){
	wget http://www.php.net/distributions/php-7.2.2.tar.xz
	prebuild php-7.2.2
	cd $package/php-7.2.2
	./configure --prefix=$prefix \
		--enable-fpm                 \
		--with-fpm-user=apache       \
		--with-fpm-group=apache      \
		--with-config-file-path=/etc \
		--with-zlib                  \
		--enable-bcmath              \
		--with-bz2                   \
		--enable-calendar            \
		--enable-dba=shared          \
		--with-gdbm                  \
		--with-gmp                   \
		--enable-ftp                 \
		--with-gettext               \
		--enable-mbstring            \
		--with-readline              
	build
}
function which(){
	wget https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
	prebuild which-2.21
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function unrar(){
	wget http://www.rarlab.com/rar/unrarsrc-5.5.8.tar.gz
	prebuild unrarsrc-5.5.8
	make -f makefile
	cp unrar $prefix/bin/
}
function autoconf(){
	wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz
	prebuild autoconf-2.13
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function gdb(){
	wget https://ftp.gnu.org/gnu/gdb/gdb-8.1.tar.xz
	prebuild gdb-8.1
	mkdir build && cd build
	../configure --prefix=$prefix --with-system-readline --without-guild
	build
}
function git(){
	wget https://www.kernel.org/pub/software/scm/git/git-2.16.2.tar.xz
	prebuild git-2.16.2
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function guile(){
	wget https://ftp.gnu.org/gnu/guile/guile-2.2.3.tar.xz
	prebuild guile-2.2.3
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function librep(){
	wget http://download.tuxfamily.org/librep/librep_0.92.7.tar.xz
	prebuild librep_0.92.7
	mkdir build && cd build
	../configure --prefix=$prefix --disable-static
	build
}
function llvm(){
	wget http://llvm.org/releases/5.0.1/llvm-5.0.1.src.tar.xz
	prebuild llvm-5.0.1.src
	mkdir build && cd build
	CC=gcc CXX=g++ cmake -DCMAKE_ISATLL_PREFIX=$prefix
	build
}
function hg(){
	wget https://www.mercurial-scm.org/release/mercurial-4.5.tar.gz
	prebuild mercurial-4.5
	make PREFIX=$prefix install-bin
	cd $package
}
function nasm(){
	wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.xz
	prebuild nasm-2.13.03
	mkdir build && cd builld
	../configure --prefix=$prefix
	build
}
function bninja(){
	wget https://github.com/ninja-build/ninja/archive/v1.8.2/ninja-1.8.2.tar.gz
	prebuild bninja-1.8.2
	python3 configure.py --bootstrap --prefix=$prefix
	cp ninja $bin
	cd $package
}
function ruby(){
	wget http://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.0.tar.xz
	prebuild ruby-2.5.0
	mkdir build && cd build
	../configure --prefix=$prefix --enable-shared
	build
}
function R(){
	wget https://mirrors.ustc.edu.cn/CRAN/src/base/R-3/R-3.5.0.tar.gz
	prebuild R-3.5.0
	mkdir build && cd build
	../configure --prefix=$prefix
	build
}
function DMD(){
	wget http://downloads.dlang.org/releases/2.x/2.080.0/dmd.2.080.0.linux.tar.xz
	prebuild dmd.2.080.0
	cp dmd2/linux/bin64/* $prefix/bin
	cp dmd2/linux/lib64/
}
function go(){
	wget https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
	prebuild go1.10.2.linux-amd64.tar.gz
	cp -r $package/go1.10.2.linux-amd64/ $prefix/go
	echo "export GOROOT=$prerfix/go" >> $HOME/.bash_profile
	echo "export PATH=$PATH:$GOROOT/bin" >> $HOME/.bash_profile
}
function TK(){
	wget https://downloads.sourceforge.net/tcl/tk8.6.8-src.tar.gz
	prebuild tk8.6.8-src
	mkdir build && cd build
	../unix/configure --prefix=$prefix --enable-64bit
	build
}
function berkeley(){
	wget http://download.oracle.com/berkeley-db/db-6.2.32.tar.gz
	prebuild db-6.2.32
	mkdir build && cd build
	../dist/configure --prefix=$prefix --enable-compat185 --enable-dbm --disable-static --enable-cxx
	build
}
function mariadb(){
	wget https://downloads.mariadb.org/interstitial/mariadb-10.2.13/source/mariadb-10.2.13.tar.gz
	prebuild mariadb-10.2.13
	mkdir build && cd build
	cmake -DCMKE_INSTALL_PREFIX=$prefix -DCMAKE_BUILD_TYPE=Release ../
	build
}
function java(){
	 wget http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz?AuthParam=1525694966_c099448c7a6136565fa11bc8623f2439 -O jdk-8u172-linux-x64.tar.gz
	prebuild jdk-8u172-linux-x64
	cp -r jdk1.8.0_172 $prefix/java
	echo "export JAVA_HOME=$prefix/java" >> $HOME/.bash_profile
	echo "export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >> $HOME/.bash_profile
	echo "export PATH=$PATH:$JAVA_HOME/bin" >>$HOME/.bash_profile
}

