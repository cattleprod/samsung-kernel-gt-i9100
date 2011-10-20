LOCAL_PATH:= $(call my-dir)

# Relative path from current dir to vendor brcm
BRCM_BT_SRC_ROOT_PATH := ../../../../vendor/samsung/common/extension/brcm

# Relative path from <mydroid> to brcm base
BRCM_BT_INC_ROOT_PATH := $(LOCAL_PATH)/../../../../vendor/samsung/common/extension/brcm

#
# libbluetoothd
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	android_bluez.c \
	adapter.c \
	agent.c \
	btio.c \
	dbus-common.c \
	dbus-hci.c \
	device.c \
	error.c \
	glib-helper.c \
	log.c \
	main.c \
	manager.c \
	oui.c \
	plugin.c \
	rfkill.c \
	sdpd-request.c \
	sdpd-service.c \
	sdpd-server.c \
	sdpd-database.c \
	sdp-xml.c \
	security.c \
	storage.c \
	textfile.c

LOCAL_CFLAGS:= \
	-DVERSION=\"4.69\" \
	-DSTORAGEDIR=\"/data/misc/bluetoothd\" \
	-DCONFIGDIR=\"/etc/bluetooth\" \
	-DSERVICEDIR=\"/system/bin\" \
	-DPLUGINDIR=\"/system/lib/bluez-plugin\" \
	-DANDROID_SET_AID_AND_CAP \
	-DANDROID_EXPAND_NAME

ifeq ($(BOARD_HAVE_BLUETOOTH_BCM),true)
LOCAL_CFLAGS += \
	-DBOARD_HAVE_BLUETOOTH_BCM
endif

ifeq ($(TARGET_BOARD_PLATFORM), omap4)
ifeq ($(BOARD_HAVE_BLUETOOTH_BCM_BTLA),true)
LOCAL_CFLAGS += \
	-DBOARD_HAVE_BLUETOOTH_BCM
endif
endif

ifeq ($(BT_ALT_STACK),true)
LOCAL_CFLAGS += -DBT_ALT_STACK
endif

LOCAL_C_INCLUDES:= \
	$(LOCAL_PATH)/../lib \
	$(LOCAL_PATH)/../gdbus \
	$(LOCAL_PATH)/../plugins \
	$(call include-path-for, glib) \
	$(call include-path-for, glib)/glib \
	$(call include-path-for, dbus)

ifeq ($(BRCM_BT_USE_BTL_IF),true)
LOCAL_SRC_FILES += \
	$(BRCM_BT_SRC_ROOT_PATH)/adaptation/dtun/dtunc_bz4/dtun_clnt.c \
	$(BRCM_BT_SRC_ROOT_PATH)/adaptation/dtun/dtunc_bz4/dtun_device.c \
	$(BRCM_BT_SRC_ROOT_PATH)/adaptation/dtun/dtunc_bz4/dtun_obex.c \
	$(BRCM_BT_SRC_ROOT_PATH)/adaptation/dtun/dtunc_bz4/dtun_hcid.c

LOCAL_C_INCLUDES += \
	$(BRCM_BT_INC_ROOT_PATH)/adaptation/dtun/include \
	$(BRCM_BT_INC_ROOT_PATH)/adaptation/dtun/dtunc_bz4

ifeq ($(TARGET_PRODUCT),GT-I9100))
LOCAL_CFLAGS += -DU1_EUR_OPEN
else ifeq ($(TARGET_PRODUCT),GT-I9103)
LOCAL_CFLAGS += -DN1_EUR_OPEN
else ifeq ($(TARGET_PRODUCT),SGH-I927)
LOCAL_CFLAGS += -DN1_USA_ATT
else ifeq ($(TARGET_PRODUCT),GT-I9100G)
LOCAL_CFLAGS += -DT1_EUR_OPEN
else ifeq ($(TARGET_PRODUCT),GT-I6200)
LOCAL_CFLAGS += -DP2_EUR_OPEN
else ifeq ($(TARGET_PRODUCT),GT-P6000)
LOCAL_CFLAGS += -DP6_EUR_OPEN
else ifeq ($(TARGET_PRODUCT),SHW-M250S)
LOCAL_CFLAGS += -DU1_KOR_SKT
else ifeq ($(TARGET_PRODUCT),SC-02C)
LOCAL_CFLAGS += -DU1_JPN_NTT
else ifeq ($(TARGET_PRODUCT),SHV-E110S)
LOCAL_CFLAGS += -DCELOX_KOR_SKT
else ifeq ($(TARGET_PRODUCT),SHV-E120S)
LOCAL_CFLAGS += -DDALI_KOR_SKT
else ifeq ($(TARGET_PRODUCT),SHV-E120K)
LOCAL_CFLAGS += -DDALI_KOR_KT
else ifeq ($(TARGET_PRODUCT),SHV-E120L)
LOCAL_CFLAGS += -DDALI_KOR_LGT
else ifeq ($(TARGET_PRODUCT),SGH-I727)
LOCAL_CFLAGS += -DCELOX_USA_ATT
else ifeq ($(TARGET_PRODUCT),SGH-T989)
LOCAL_CFLAGS += -DCELOX_USA_TMO
else ifeq ($(TARGET_PRODUCT),SC-02D)
LOCAL_CFLAGS += -DCELOX_JPN_NTT
else ifeq ($(TARGET_PRODUCT),SPH-D710)
LOCAL_CFLAGS += -DU1_EUR_OPEN
LOCAL_CFLAGS += -DU1_NA_SPR
else ifeq ($(TARGET_PRODUCT),SPH-D705)
LOCAL_CFLAGS += -DU1_EUR_OPEN
LOCAL_CFLAGS += -DU1_NA_SPR
else ifeq ($(TARGET_PRODUCT),SGH-I777)
LOCAL_CFLAGS += -DU1_USA_ATT
endif

LOCAL_CFLAGS += -DBRCM_BT_USE_BTL_IF -DBT_USE_BTL_IF
endif

LOCAL_SHARED_LIBRARIES := \
	libdl \
	libbluetooth \
	libdbus \
	libcutils

LOCAL_STATIC_LIBRARIES := \
	libglib_static \
	libbuiltinplugin \
	libgdbus_static

LOCAL_MODULE:=libbluetoothd

include $(BUILD_SHARED_LIBRARY)

#
# bluetoothd
#

include $(CLEAR_VARS)

LOCAL_SHARED_LIBRARIES := \
	libbluetoothd

LOCAL_MODULE:=bluetoothd

include $(BUILD_EXECUTABLE)
