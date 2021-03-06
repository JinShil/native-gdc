#!/bin/bash

# Copyright © 2018 Michael V. Franklin
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

DIR=`pwd`
GDC_BRANCH=master

# Creating a Directory Structure
rm -rf $DIR/src/
rm -rf $DIR/src/gcc/
rm -rf $DIR/src/build/
rm -rf $DIR/usr/

mkdir $DIR/src/
mkdir $DIR/src/gcc/
mkdir $DIR/src/build/
mkdir $DIR/usr/

GCC_VERSION=10-20190505

# Obtain the GCC Source Code and Extract it
cd $DIR/src/
GCC_MIRROR=ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/snapshots
GCC_NAME=$GCC_VERSION
GCC_SOURCE_ARCHIVE=gcc-$GCC_NAME.tar.xz
wget $GCC_MIRROR/$GCC_NAME/$GCC_SOURCE_ARCHIVE
tar xfv $GCC_SOURCE_ARCHIVE --strip-components=1 -C gcc
rm $GCC_SOURCE_ARCHIVE

# Configure GCC
cd $DIR/src/build/
../gcc/configure         \
  --enable-languages=d   \
  --disable-bootstrap    \
  --prefix=/usr          \
  --disable-multilib     \
  --disable-libgomp      \
  --disable-libmudflap   \
  --disable-libquadmath

# Build GCC
cd $DIR/src/build/
make CXXFLAGS="-g3 -O0" -j4 2>&1 | tee build.log

# Install GCC
cd $DIR/src/build/
export DESTDIR=$DIR
make install
