# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)

PKG_NAME="hyperhdr"
PKG_VERSION="99bea943ffdd9742466cd4ec2551d2cbde2602c6"
PKG_REV="183"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/awawa-dev/HyperHDR"
PKG_URL="https://github.com/awawa-dev/HyperHDR.git"
GET_HANDLER_SUPPORT="git"
PKG_DEPENDS_TARGET="toolchain avahi qt-everywhere protobuf pkg-config libjpeg-turbo alsa"
PKG_TOOLCHAIN="cmake"
PKG_SECTION="service"
PKG_SHORTDESC="HyperHDR: an ambient lighting controller"
PKG_LONGDESC="HyperHDR (v18.0.0.0beta2.elec) is an opensource ambient lighting implementation."

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="HyperHDR"
PKG_ADDON_TYPE="xbmc.service"

# Setting default values
PKG_PLATFORM="-DPLATFORM=x86"
PKG_DENABLE_WS281XPWM="-DENABLE_WS281XPWM=0"

if [ "$KODIPLAYER_DRIVER" = "libamcodec" ]; then
  PKG_PLATFORM="-DPLATFORM=linux"
elif [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
  PKG_PLATFORM="-DPLATFORM=rpi"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver rpi_ws281x"
  PKG_DENABLE_WS281XPWM="-DENABLE_WS281XPWM=1"
elif [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET xorg-server xrandr"
fi

PKG_CMAKE_OPTS_TARGET="-DCMAKE_NO_SYSTEM_FROM_IMPORTED=ON \
                       -DCMAKE_BUILD_TYPE=Release \
                       -DUSE_SHARED_AVAHI_LIBS=OFF\
                       -DUSE_STATIC_QT_PLUGINS=ON \
                       $PKG_PLATFORM \
                       $PKG_DENABLE_WS281XPWM \
                       -Wno-dev"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/{bin,lib,lut}  
  cp -r -P -p $(get_install_dir hyperhdr)/usr/share/hyperhdr/bin/* ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp -r -P $(get_install_dir hyperhdr)/usr/share/hyperhdr/lib/* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib
  tar -xf $(get_install_dir hyperhdr)/usr/share/hyperhdr/lut/lut_lin_tables.tar.xz -C ${ADDON_BUILD}/${PKG_ADDON_ID}/lut
}
