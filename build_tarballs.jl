using BinaryBuilder

name = "ncurses"
version = v"6.1"

sources = [
    "https://invisible-mirror.net/archives/ncurses/ncurses-6.1.tar.gz" =>
        "aa057eeeb4a14d470101eff4597d5833dcef5965331be3528c08d99cebaa0d17",
]

script = raw"""
# tic for host
cd ${WORKSPACE}/srcdir/ncurses-*
./configure CC="$CC_FOR_BUILD" CXX="$CXX_FOR_BUILD" RANLIB=$RANLIB_FOR_BUILD LD=$LD_FOR_BUILD CFLAGS="" LDFLAGS="" --without-shared --with-normal --disable-mixed-case
make -C include
make -C progs tic
cp progs/tic /usr/bin

make distclean
./configure --prefix=${prefix} --host=${target} --build=x86_64-linux-gnu --with-shared --without-progs --with-build-cc="$CC_FOR_BUILD" --with-termlib --without-progs --without-tack --without-tests --without-manpages --without-normal --disable-mixed-case
make -j${nproc}
make install

# avoid case-insensitive file system problems...
rm -f $prefix/share/terminfo/*/hp70092A
rm -f $prefix/share/terminfo/*/2621a
rm -f $prefix/share/terminfo/*/hp2621a
"""

products(prefix) = [
    LibraryProduct(prefix, "libncurses", :libncurses),
    LibraryProduct(prefix, "libtinfo", :libtinfo)
]

platforms = filter(x->!isa(x,Windows),supported_platforms())

dependencies = [
]

build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
