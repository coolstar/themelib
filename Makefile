ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = ThemeLib
ThemeLib_FILES = Badges.xm Clock.xm
ThemeLib_FRAMEWORKS = UIKit CoreGraphics
ThemeLib_OBJ_FILES = UIColor+HTMLColors.mm.o

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += themelibuikit
SUBPROJECTS += cardump
include $(THEOS_MAKE_PATH)/aggregate.mk
