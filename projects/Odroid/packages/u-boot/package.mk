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
case $DEVICE in
  U2|XU3) PKG_VERSION="2015.10" ; PKG_URL="ftp://ftp.denx.de/pub/u-boot/u-boot-$PKG_VERSION.tar.bz2" ;;
  C1)     PKG_VERSION="2011.03+e7d4447" ; PKG_URL="$ODROID_MIRROR/$PKG_NAME-$PKG_VERSION.tar.xz" ; PKG_OTHER_DEPENDS="linaro-arm-toolchain:host" ;;
  C2)     PKG_VERSION="2015.01" ; PKG_URL="ftp://ftp.denx.de/pub/u-boot/u-boot-$PKG_VERSION.tar.bz2" ;;
esac
PKG_SITE="http://www.denx.de/wiki/U-Boot/WebHome"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain dtc:host hk-bootloader $PKG_OTHER_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="u-boot: Universal Bootloader project"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems, used as the default boot loader by several board vendors. It is intended to be easy to port and to debug, and runs on many supported architectures, including PPC, ARM, MIPS, x86, m68k, NIOS, and Microblaze."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  unset LDFLAGS

# dont use some optimizations because of problems
  MAKEFLAGS=-j1
}

make_target() {
  case $DEVICE in
    U2|XU3|C2)
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" $UBOOT_CONFIG
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" HOSTCC="$HOST_CC" HOSTSTRIP="true"
      ;;
    C1)
      make CROSS_COMPILE="arm-none-eabi-" $UBOOT_CONFIG
      make CROSS_COMPILE="arm-none-eabi-" HOSTCC="$HOST_CC" HOSTSTRIP="true"
      ;;
  esac
}

makeinstall_target() {
  mkdir -p $ROOT/$TOOLCHAIN/bin

  if [ -f build/tools/mkimage ]; then
    cp build/tools/mkimage $ROOT/$TOOLCHAIN/bin
  elif [ -f tools/mkimage ]; then
    cp tools/mkimage $ROOT/$TOOLCHAIN/bin
  fi

  mkdir -p $INSTALL/usr/share/bootloader

  if [ -f "./u-boot-dtb.bin" ]; then
    cp -PRv ./u-boot-dtb.bin $INSTALL/usr/share/bootloader/u-boot
  elif [ -f "./u-boot.bin" ]; then
    cp -PRv ./u-boot.bin $INSTALL/usr/share/bootloader/u-boot
  elif [ -f "./sd_fuse/u-boot.bin" ]; then
    cp -PRv ./sd_fuse/u-boot.bin $INSTALL/usr/share/bootloader/u-boot
  fi

  case $DEVICE in
    U2|XU3) cp -PRv $PKG_DIR/scripts/update-u2.sh $INSTALL/usr/share/bootloader/update.sh ;;
    C1)     cp -PRv $PKG_DIR/scripts/update-c1.sh $INSTALL/usr/share/bootloader/update.sh ;;
    C2)     cp -PRv $PKG_DIR/scripts/update-c2.sh $INSTALL/usr/share/bootloader/update.sh ;;
  esac
}
