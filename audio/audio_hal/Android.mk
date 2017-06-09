#AUDIO_POLICY_TEST := true
#ENABLE_AUDIO_DUMP := true

LOCAL_PATH := $(call my-dir)

# ---------------------------------------------------------------------------------
#             Make the Shared library libaudiopolicy
# ---------------------------------------------------------------------------------

include $(CLEAR_VARS)

common_cflags := -D_POSIX_SOURCE
ifeq ($(strip $(AUDIO_FEATURE_ENABLED_FM)),true)
    common_cflags += -DQCOM_FM_ENABLED
endif
ifeq ($(strip $(QCOM_PROXY_DEVICE_ENABLED)),true)
    common_cflags += -DQCOM_PROXY_DEVICE_ENABLED
endif
ifeq ($(strip $(QCOM_OUTPUT_FLAGS_ENABLED)),true)
    common_cflags += -DQCOM_OUTPUT_FLAGS_ENABLED
endif

include $(CLEAR_VARS)

LOCAL_CFLAGS += $(common_cflags)

ifeq ($(BOARD_USES_STEREO_HW_SPEAKER),true)
    LOCAL_CFLAGS += -DWITH_STEREO_HW_SPEAKER
endif

ifeq ($(BOARD_HAVE_SAMSUNG_AUDIO),true)
    LOCAL_CFLAGS += -DSAMSUNG_AUDIO
endif

ifeq ($(BOARD_HAVE_SEMC_AUDIO),true)
    LOCAL_CFLAGS += -DSEMC_AUDIO
endif

LOCAL_SRC_FILES := \
    AudioHardware.cpp \
    audio_hw_hal.cpp

LOCAL_SHARED_LIBRARIES := \
    libcutils       \
    libutils        \
    libmedia        \
    libaudioalsa

ifeq ($(BOARD_USES_QCOM_AUDIO_CALIBRATION),true)
    LOCAL_SHARED_LIBRARIES += libaudcal
    LOCAL_CFLAGS += -DWITH_QCOM_CALIBRATION
endif

ifneq ($(TARGET_SIMULATOR),true)
    LOCAL_SHARED_LIBRARIES += libdl
endif

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper \
    libaudiohw_legacy

LOCAL_MODULE := audio.primary.msm7x30

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

LOCAL_CFLAGS += -fno-short-enums

LOCAL_C_INCLUDES := $(TARGET_OUT_HEADERS)/mm-audio/audio-alsa
ifeq ($(BOARD_USES_QCOM_AUDIO_CALIBRATION),true)
    LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/mm-audio/audcal
endif
LOCAL_C_INCLUDES += hardware/libhardware/include
LOCAL_C_INCLUDES += hardware/libhardware_legacy/include
LOCAL_C_INCLUDES += frameworks/base/include
LOCAL_C_INCLUDES += system/core/include

LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

include $(BUILD_SHARED_LIBRARY)
