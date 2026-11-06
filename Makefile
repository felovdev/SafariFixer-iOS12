TARGET := iphone:clang:latest:12.0
ARCHS := arm64
INSTALL_TARGET_PROCESSES := MobileSafari

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := SafariFixer
SafariFixer_FILES := Tweak.xm
SafariFixer_CFLAGS := -fobjc-arc
SafariFixer_FRAMEWORKS := Foundation WebKit

include $(THEOS_MAKE_PATH)/tweak.mk
