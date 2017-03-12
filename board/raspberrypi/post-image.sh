#!/bin/sh

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

for i in "$@"
do
case "$i" in
	--add-pi3-miniuart-bt-overlay)
	if ! grep -qE '^dtoverlay=pi3-miniuart-bt' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
		echo "Adding 'dtoverlay=pi3-miniuart-bt' to config.txt (fixes ttyAMA0 serial console)."
		cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Fixes rpi3 ttyAMA0 serial console
dtoverlay=pi3-miniuart-bt
__EOF__
	fi
	;;
	--tvmode-720)
	if ! grep -qE '^hdmi_mode=4' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
		echo "Adding 'tvmode=720' to config.txt."
		cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Force 720p
hdmi_group=1
hdmi_mode=4
__EOF__
	fi
	;;
esac
done

INITRAMFS="$(grep ^BR2_TARGET_ROOTFS_INITRAMFS=y ${BR2_CONFIG})"
ROOTFS_CPIO="$(grep ^BR2_TARGET_ROOTFS_CPIO=y ${BR2_CONFIG})"
ROOTFS_EXT4="$(grep ^BR2_TARGET_ROOTFS_EXT2_4=y ${BR2_CONFIG})"

if [ "x${ROOTFS_EXT4}" != "x" ]; then
	rm -rf "${GENIMAGE_TMP}"
	genimage                           \
		--rootpath "${TARGET_DIR}"     \
		--tmppath "${GENIMAGE_TMP}"    \
		--inputpath "${BINARIES_DIR}"  \
		--outputpath "${BINARIES_DIR}" \
		--config "${GENIMAGE_CFG}"
elif [ "x${INITRAMFS}" = "x" ] && [ "x${ROOTFS_CPIO}" != "x" ]; then
	CPIO_XZ=$(grep ^BR2_TARGET_ROOTFS_CPIO_XZ=y ${BR2_CONFIG})
	CPIO_GZIP=$(grep ^BR2_TARGET_ROOTFS_CPIO_GZIP=y ${BR2_CONFIG})
	sed -i 's/#initramfs/initramfs/g' "${BINARIES_DIR}/rpi-firmware/config.txt"
	if [ "x${CPIO_XZ}" != "x" ]; then
		sed -i 's/cpio.gz/cpio.xz/' "${BINARIES_DIR}/rpi-firmware/config.txt"
	elif [ "x${CPIO_GZIP}" = "x" ]; then
		sed -i 's/cpio.gz/rootfs.cpio/' "${BINARIES_DIR}/rpi-firmware/config.txt"
	fi
fi

exit $?
