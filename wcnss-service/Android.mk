ifeq ($(TARGET_ARCH),arm)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := wcnss_service
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/common/inc/

ifeq ($(TARGET_USES_WCNSS_CTRL),true)
LOCAL_SRC_FILES := wcnss_service.c
else
LOCAL_SRC_FILES := wcnss_service_old.c
endif

LOCAL_SHARED_LIBRARIES := libc libcutils libutils liblog

ifeq ($(strip $(TARGET_USES_QCOM_WCNSS_QMI)),true)
ifeq ($(TARGET_USES_WCNSS_MAC_ADDR_REV),true)
LOCAL_CFLAGS += -DWCNSS_QMI_MAC_ADDR_REV
endif
ifneq ($(QCPATH),)
LOCAL_CFLAGS += -DWCNSS_QMI
LOCAL_SHARED_LIBRARIES += libwcnss_qmi
else
LOCAL_CFLAGS += -DWCNSS_QMI_OSS
LOCAL_SHARED_LIBRARIES += libdl
endif #QCPATH
endif #TARGET_USES_QCOM_WCNSS_QMI

LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS += -Wall

include $(BUILD_EXECUTABLE)

ifeq ($(strip $(TARGET_USES_QCOM_WCNSS_QMI)),true)
ifneq ($(QCPATH),)
include $(CLEAR_VARS)

LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi/inc
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi/services
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi/platform
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi/src
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi/core/lib/inc

LOCAL_SHARED_LIBRARIES := libc libcutils libutils liblog
LOCAL_SHARED_LIBRARIES += libqmiservices libqmi libqcci_legacy libqmi_client_qmux

ifneq ($(TARGET_WCNSS_MAC_PREFIX),)
    LOCAL_CFLAGS += -DWCNSS_INVALID_MAC_PREFIX=\"$(TARGET_WCNSS_MAC_PREFIX)\"
endif

LOCAL_CFLAGS += -DWCNSS_QMI
LOCAL_SRC_FILES += wcnss_qmi_client.c

LOCAL_MODULE := libwcnss_qmi
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS += -Wall

include $(BUILD_SHARED_LIBRARY)

endif #QCPATH
endif #TARGET_USES_QCOM_WCNSS_QMI

endif #TARGET_ARCH == arm
