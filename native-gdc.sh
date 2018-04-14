#!/bin/bash

# Copyright © 2015 Michael V. Franklin
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file. If not, see <http://www.gnu.org/licenses/>.

# References
#------------------------------------------------------------------
# https://wiki.dlang.org/GDC/Development/DevelopmentEnvironment

# stop if an error is encountered
set -e

export DIR=`pwd`

# Creating a Directory Structure
rm -rf $DIR/gdc-src/
rm -rf $DIR/gdc-src/gcc/
rm -rf $DIR/gdc-src/gdc/
rm -rf $DIR/gdc-src/build/
rm -rf $DIR/usr/

mkdir $DIR/gdc-src/
mkdir $DIR/gdc-src/gcc/
mkdir $DIR/gdc-src/gdc/
mkdir $DIR/gdc-src/build/
mkdir $DIR/usr/

# Obtain the GCC Source Code and Extract it
cd $DIR/gdc-src/
export GCC_MIRROR=http://ftpmirror.gnu.org/gcc
export GCC_NAME=gcc-7.3.0
export GCC_SOURCE_ARCHIVE=$GCC_NAME.tar.xz
wget $GCC_MIRROR/$GCC_NAME/$GCC_SOURCE_ARCHIVE
tar xfv $GCC_SOURCE_ARCHIVE --strip-components=1 -C gcc
rm $GCC_SOURCE_ARCHIVE

# Obtain the GDC Source Code
cd $DIR/gdc-src/gdc/
git clone https://github.com/D-Programming-GDC/GDC.git .
git checkout gdc-7

# Add GDC to GCC
cd $DIR/gdc-src/gdc/
./setup-gcc.sh $DIR/gdc-src/gcc

# Configure GCC
cd $DIR/gdc-src/build/
../gcc/configure         \
  --enable-languages=d   \
  --disable-bootstrap    \
  --prefix=/usr          \
  --disable-multilib     \
  --disable-libgomp      \
  --disable-libmudflap   \
  --disable-libquadmath

# Build GCC
cd $DIR/gdc-src/build/
make CXXFLAGS="-g3 -O0" -j4 2>&1 | tee build.log

# Install GCC
cd $DIR/gdc-src/build/
export DESTDIR=$DIR
make install
