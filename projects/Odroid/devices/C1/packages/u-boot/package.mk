################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="u-boot"
PKG_VERSION="2011.03+e7d4447"
PKG_SITE="http://hardkernel.org"
PKG_URL="$ODROID_MIRROR/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain lzop:host linaro-arm-toolchain:host"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="u-boot: Universal Bootloader project"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems, used as the default boot loader by several board vendors. It is intended to be easy to port and to debug, and runs on many supported architectures, including PPC, ARM, MIPS, x86, m68k, NIOS, and Microblaze."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  unset LDFLAGS CFLAGS CPPFLAGS

# dont use some optimizations because of problems
  MAKEFLAGS=-j1
}

make_target() {
  make CROSS_COMPILE="arm-none-eabi-" $UBOOT_CONFIG
  make CROSS_COMPILE="arm-none-eabi-" HOSTCC="$HOST_CC" HOSTSTRIP="true"
}

makeinstall_target() {
  mkdir -p $ROOT/$TOOLCHAIN/bin

  if [ -f build/tools/mkimage ]; then
    cp build/tools/mkimage $ROOT/$TOOLCHAIN/bin
  elif [ -f tools/mkimage ]; then
    cp tools/mkimage $ROOT/$TOOLCHAIN/bin
  fi

  mkdir -p $INSTALL/usr/share/bootloader

  for f in bl1.bin.hardkernel u-boot.bin; do
    cp -PRv $ROOT/$PKG_BUILD/sd_fuse/$f $INSTALL/usr/share/bootloader/${f/.*}
  done

  cp -PRv $PKG_DIR/scripts/update.sh $INSTALL/usr/share/bootloader
}
