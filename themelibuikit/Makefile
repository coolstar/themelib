ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = ThemeLibUIKit
ThemeLibUIKit_FILES = UIKitCar.xm ExternalCar.xm Preferences.xm ThemeLibSettingsManager.mm
ThemeLibUIKit_FRAMEWORKS = UIKit CoreGraphics ImageIO

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
