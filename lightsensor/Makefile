ARCHS = arm64 armv7 armv7s armv6
TARGET = iphone:clang:latest:9.0
include $(THEOS)/makefiles/common.mk

TOOL_NAME = lightsensor
lightsensor_FILES = main.m
lightsensor_CFLAGS = -fobjc-arc
lightsensor_FRAMEWORKS = IOKit Foundation

include $(THEOS_MAKE_PATH)/tool.mk
