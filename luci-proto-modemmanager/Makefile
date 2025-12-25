#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Support for ModemManager
LUCI_DEPENDS:=+modemmanager +luci-base

PKG_NAME:=luci-proto-modemmanager
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Nicholas Smith <nicholas@nbembedded.com>

include $(INCLUDE_DIR)/package.mk

define Package/luci-proto-modemmanager
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=5. Protocols
  TITLE:=$(LUCI_TITLE)
  DEPENDS:=$(LUCI_DEPENDS)
  PKGARCH:=all
endef

define Package/luci-proto-modemmanager/description
  LuCI support for ModemManager protocol
endef

define Build/Compile
endef

define Package/luci-proto-modemmanager/install
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./root/usr/share/luci/menu.d/*.json $(1)/usr/share/luci/menu.d/
	
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./root/usr/share/rpcd/acl.d/*.json $(1)/usr/share/rpcd/acl.d/
	
	$(INSTALL_DIR) $(1)/www/luci-static/resources/protocol
	$(INSTALL_DATA) ./htdocs/luci-static/resources/protocol/*.js $(1)/www/luci-static/resources/protocol/
	
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/modemmanager
	$(INSTALL_DATA) ./htdocs/luci-static/resources/view/modemmanager/*.js $(1)/www/luci-static/resources/view/modemmanager/
	
	$(INSTALL_DIR) $(1)/www/luci-static/resources
	$(INSTALL_DATA) ./htdocs/luci-static/resources/*.js $(1)/www/luci-static/resources/
endef

$(eval $(call BuildPackage,luci-proto-modemmanager))
