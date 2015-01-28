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

PKG_NAME="xf86-video-armsoc"
case $DEVICE in
  U2) PKG_VERSION="29356f5" ;;
  XU3) PKG_VERSION="1.1.0" ;;
esac
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE=""
PKG_SITE="http://www.hardkernel.org"
PKG_URL="$ODROID_MIRROR/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-macros xorg-server"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="x11/driver"
PKG_SHORTDESC="xf86-video-armsoc: The Xorg driver for some ARM video chips"
PKG_LONGDESC=""

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-xorg-module-dir=$XORG_PATH_MODULES --with-drmmode=exynos"

post_makeinstall_target() {
  mkdir -p $INSTALL/etc/X11/xorg.conf.d
    cp $PKG_DIR/config/*.conf $INSTALL/etc/X11/xorg.conf.d/20-armsoc.conf
}
