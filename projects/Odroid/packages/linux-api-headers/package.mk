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

PKG_NAME="linux-api-headers"
PKG_VERSION="3.19"
PKG_URL="http://www.kernel.org/pub/linux/kernel/v3.0/linux-$PKG_VERSION.tar.xz"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kernel.org"
PKG_DEPENDS_HOST="ccache:host"
PKG_PRIORITY="optional"
PKG_SECTION="linux"
PKG_SHORTDESC="linux-api-headers: Linux kernel headers sanitized for development use"
PKG_LONGDESC="linux-api-headers: Linux kernel headers sanitized for development use"
PKG_SOURCE_DIR="linux-$PKG_VERSION"

case $DEVICE in
  C2)  ARCH=arm64 ;;
   *)  ARCH=$TARGET_ARCH ;;
esac

unpack() { 
  $SCRIPTS/extract $PKG_NAME $(basename $PKG_URL) $BUILD
}

pre_make_host() {
  make ARCH=$ARCH mrproper
}

make_host() {
  make ARCH=$ARCH headers_check
}

makeinstall_host() { 
  make ARCH=$ARCH INSTALL_HDR_PATH=dest headers_install
}

post_makeinstall_host() {
  mkdir -p $SYSROOT_PREFIX/usr/include
  cp -R dest/include/* $SYSROOT_PREFIX/usr/include
}
