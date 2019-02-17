################################################################################
#
# soft_control_rust
#
################################################################################

SOFT_CONTROL_RUST_VERSION = 0.1.1
SOFT_CONTROL_RUST_SITE = $(HOME)/Projects/softbot/softcontrol/rust/soft_control
SOFT_CONTROL_RUST_SITE_METHOD = local
SOFT_CONTROL_RUST_LICENSE = Public Domain

SOFT_CONTROL_RUST_DEPENDENCIES = host-cargo

SOFT_CONTROL_RUST_CARGO_ENV = \
    CARGO_HOME=$(HOST_DIR)/share/cargo \
    RUST_TARGET_PATH=$(HOST_DIR)/etc/rustc \
	LD_LIBRARY_PATH=$(HOST_DIR)/usr/lib \
	PKG_CONFIG_ALLOW_CROSS=1


SOFT_CONTROL_RUST_CARGO_OPTS = \
	--target=$(RUSTC_TARGET_NAME) \
	--manifest-path=$(@D)/Cargo.toml

ifeq ($(BR2_ENABLE_DEBUG),y)
SOFT_CONTROL_RUST_CARGO_MODE = debug
else
SOFT_CONTROL_RUST_CARGO_MODE = release
endif
SOFT_CONTROL_RUST_CARGO_OPTS += --$(SOFT_CONTROL_RUST_CARGO_MODE)

define SOFT_CONTROL_RUST_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(SOFT_CONTROL_RUST_CARGO_ENV) \
            cargo build $(SOFT_CONTROL_RUST_CARGO_OPTS)
endef

define SOFT_CONTROL_RUST_INSTALL_TARGET_CMDS
    $(INSTALL) -D \
            $(@D)/target/$(RUSTC_TARGET_NAME)/$(SOFT_CONTROL_RUST_CARGO_MODE)/soft_control \
            $(TARGET_DIR)/usr/bin/soft_control
endef

$(eval $(generic-package))
