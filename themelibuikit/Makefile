include theos/makefiles/common.mk

TWEAK_NAME = ThemeLibUIKit
ThemeLibUIKit_FILES = UIKitCar.xm
ThemeLibUIKit_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
