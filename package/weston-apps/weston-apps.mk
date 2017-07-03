################################################################################
#
# weston-apps
#
################################################################################

WESTON_APPS_VERSION = 0.0.0
WESTON_APPS_SITE = 
WESTON_APPS_SOURCE = 
WESTON_APPS_INSTALL_STAGING = YES
WESTON_APPS_INSTALL_TARGET = YES

WESTON_APPS_DEPENDENCIES = libegl
WESTON_APPS_CONF_OPTS = 

ifeq ($(BR2_PACKAGE_WESTEROS_EXTENDED),y)
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS=ON

ifeq ($(BR2_PACKAGE_HAS_KYLIN),y)
WESTON_APPS_CONF_OPTS += -DWESTEROS_PLATFORM_KYLIN=1
WESTON_APPS_CONF_OPTS += -DPLATFORM_LIB_INCLUDE_DIR=$(STAGING_DIR)/usr/include/realtek
WESTON_APPS_CONF_OPTS += -DPLATFORM_LIB_LIB_DIR=$(STAGING_DIR)/usr/lib
else
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
WESTON_APPS_CONF_OPTS += -DWESTEROS_PLATFORM_RPI=1
else
KYLIN_WESTON_DEPENDENCIES += libdrm
endif
endif

ifeq ($(BR2_PACKAGE_WESTEROS_APP),y)
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS_APP=ON
else
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS_APP=OFF
endif

ifeq ($(BR2_PACKAGE_WESTEROS_PLAYER),y)
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS_PLAYER=ON
else
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS_PLAYER=OFF
endif

ifeq ($(BR2_PACKAGE_WESTEROS_TEST),y)
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS_TEST=ON
else
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS_TEST=OFF
endif

ifeq ($(BR2_PACKAGE_WESTEROS_XDGV4_SHELL),y)
WESTON_APPS_CONF_OPTS += -DENABLE_XDG_V4=ON
else
WESTON_APPS_CONF_OPTS += -DENABLE_XDG_V4=OFF
endif

ifeq ($(BR2_PACKAGE_WESTEROS_XDGV5_SHELL),y)
WESTON_APPS_CONF_OPTS += -DENABLE_XDG_V5=ON
else
WESTON_APPS_CONF_OPTS += -DENABLE_XDG_V5=OFF
endif

ifeq ($(BR2_PACKAGE_WESTEROS_SB_PROTOCOL),y)
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS_SBPROTOCOL=ON
else
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS_SBPROTOCOL=OFF
endif

else
WESTON_APPS_CONF_OPTS += -DENABLE_WESTEROS=OFF
endif

$(eval $(cmake-package))
