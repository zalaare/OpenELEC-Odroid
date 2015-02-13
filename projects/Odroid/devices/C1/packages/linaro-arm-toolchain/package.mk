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

PKG_NAME="linaro-arm-toolchain"
PKG_VERSION="4.9-2014"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="other"
PKG_SITE="http://releases.linaro.org"
PKG_LINK="components/toolchain/binaries"
case "`uname -m`" in
  x86_64)
    PKG_URL="$PKG_SITE/14.11/$PKG_LINK/arm-none-eabi/gcc-linaro-$PKG_VERSION.11-x86_64_arm-eabi.tar.xz"
    PKG_SOURCE_DIR="gcc-linaro-$PKG_VERSION.11-x86_64_arm-eabi"
    ;;
  i?86)
    PKG_URL="$PKG_SITE/14.09/$PKG_LINK/gcc-linaro-arm-none-eabi-$PKG_VERSION.09_linux.tar.xz"
    PKG_SOURCE_DIR="gcc-linaro-arm-none-eabi-$PKG_VERSION.09_linux"
    ;;
esac
PKG_HOST_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="Linaro GCC Compiler for ARM"
PKG_LONGDESC="Linaro GCC Compiler for ARM"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  $SCRIPTS/extract $PKG_NAME $(basename $PKG_URL) $BUILD
}

configure_host() {
  : # nothing to do
}

make_host() {
  : # nothing to do
}

makeinstall_host() {
  rm -f share/aclocal/pkg.m4
  rm -r share/doc
  cp -PR * $ROOT/$TOOLCHAIN
}
