################################################################################
#
# playready
#
################################################################################

PLAYREADY_VERSION = 3f1ed46727fa51fc39135b8545857784a109f92e
PLAYREADY_SITE = git@github.com:Metrological/playready.git
PLAYREADY_SITE_METHOD = git
PLAYREADY_LICENSE = PROPRIETARY
PLAYREADY_DEPENDENCIES = 
PLAYREADY_INSTALL_STAGING = YES
PLAYREADY_INSTALL_TARGET = YES
PLAYREADY_SUBDIR = src

PLAYREADY_CONF_OPTS = \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_FLAGS="-std=c99 -D_GNU_SOURCE"

ifeq ($(BR2_PACKAGE_LIBPROVISION),y)
PLAYREADY_CONF_OPTS += \
	-DPLAYREADY_USE_PROVISION=ON
PLAYREADY_DEPENDENCIES += libprovision
endif

ifeq ($(BR2_PACKAGE_GLUELOGIC_PROVISIONING),y)
PLAYREADY_CONF_OPTS += \
	-DPLAYREADY_USE_PROVISION=ON
PLAYREADY_DEPENDENCIES += gluelogic 
endif

define PLAYREADY_INSTALL_STAGING_PC
	$(INSTALL) -D package/playready/playready.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/playready.pc
endef

define PLAYREADY_INSTALL_TARGET_ETC_PLAYREADY
	if [ -f package/playready/bgroupcert.dat ]; then \
		$(INSTALL) -D -m 0644 package/playready/bgroupcert.dat $(TARGET_DIR)/etc/playready/; \
	fi
	if [ -f package/playready/zgpriv.dat ]; then \
		$(INSTALL) -D -m 0644 package/playready/zgpriv.dat $(TARGET_DIR)/etc/playready/; \
	fi
	ln -sf /tmp $(TARGET_DIR)/etc/playready/storage
endef

PLAYREADY_POST_INSTALL_STAGING_HOOKS += PLAYREADY_INSTALL_STAGING_PC
PLAYREADY_POST_INSTALL_TARGET_HOOKS += PLAYREADY_INSTALL_TARGET_ETC_PLAYREADY

$(eval $(cmake-package))
