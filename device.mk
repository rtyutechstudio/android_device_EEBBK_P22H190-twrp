#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/EEBBK/P22H190
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# f2fs utilities
PRODUCT_PACKAGES += \
    sg_write_buffer \
    f2fs_io \
    check_f2fs
    
# Userdata checkpoint
PRODUCT_PACKAGES += \
    checkpoint_gc

# Fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    android.hardware.fastboot@1.0-impl-mock.recovery \
    fastbootd

# OTA Certs
PRODUCT_EXTRA_RECOVERY_KEYS += \
    $(LOCAL_PATH)/security/releasekey