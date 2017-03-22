################################################################################
#
# playready
#
################################################################################

PLAYREADY_VERSION = b1aa9eea2fde6fdae631decef8b5d520afde0234
PLAYREADY_SITE = git@github.com:Metrological/playready.git
PLAYREADY_SITE_METHOD = git
PLAYREADY_LICENSE = PROPRIETARY
PLAYREADY_DEPENDENCIES = 
PLAYREADY_INSTALL_STAGING = YES
PLAYREADY_INSTALL_TARGET = YES
PLAYREADY_SUBDIR = src

ifeq ($(BR2_PACKAGE_LIBPROVISION),y)
PLAYREADY_CONF_OPTS += \
	-DPLAYREADY_USE_PROVISION=ON
PLAYREADY_DEPENDENCIES += libprovision
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
