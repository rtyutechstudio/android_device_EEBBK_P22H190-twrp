#
# Copyright (C) 2024 The TWRP Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Inherit from those products. Most specific first.

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)


# Inherit some common twrp stuff.
$(call inherit-product-if-exists, vendor/twrp/config/common.mk)

# Inherit from P22H190 device
$(call inherit-product, device/EEBBK/P22H190/device.mk)

PRODUCT_DEVICE := P22H190
PRODUCT_NAME := twrp_P22H190
PRODUCT_BRAND := EEBBK
PRODUCT_MODEL := P22H190
PRODUCT_MANUFACTURER := EEBBK



PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="EEBBK ums512_1h190_Natv_Tablet ums512_1h190:11 RP1A.201005.001 51205:eng release-keys"

BUILD_FINGERPRINT := EEBBK/ums512_1h190_Natv_Tablet/ums512_1h190:11/RP1A.201005.001/51205:eng/release-keys
