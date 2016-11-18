#!/bin/bash

# Based on:
# https://github.com/Cheapskate01/Cross-Compiler-Build-Script/blob/master/cross-compiler.sh
# http://wiki.osdev.org/GCC_Cross-Compiler

# Where our corss-compiler eventually ends up.
mkdir -p ~/opt/cross

# GCC sources needed to build the cross-compiler go here.
mkdir ~/src
cd $HOME/src

# Install GCC dependencies, which is mostly support for floating point arithmetic.
sudo apt install     \
    libgmp3-dev      \
    libmpfr-dev      \
    libisl-dev       \
    libcloog-isl-dev \
    libmpc-dev       \
    texinfo -y

# Download binutils (GNU linker, assembler etc.).
wget ftp://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz

# Download GCC.
wget ftp://ftp.gnu.org/gnu/gcc/gcc-6.2.0/gcc-6.2.0.tar.gz

tar -xvzf binutils-2.27.tar.gz
tar -xvzf gcc-6.2.0.tar.gz

export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

# Build binutils
mkdir build-binutils
cd build-binutils
../binutils-2.27/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

cd $HOME/src
which -- $TARGET-as || echo $TARGET-as is not in the PATH

# Build cross-compiler
mkdir build-gcc
cd build-gcc
../gcc-6.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
