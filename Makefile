# Makefile for IOPatternLock

MODULE_NAME = IOPatternLock
TARGET_SDK_VERSION = 9.0

BUILD := release
SOURCE_ROOT_DIR = $(shell pwd)
BUILD_ROOT_DIR = $(SOURCE_ROOT_DIR)/Build/$(MODULE_NAME)
OBJECTS_ROOT_DIR = $(BUILD_ROOT_DIR)/Objects
PRODUCT_STATIC_LIBRARY_DIR = $(BUILD_ROOT_DIR)/Static
PRODUCT_FRAMEWORK_DIR = $(BUILD_ROOT_DIR)/Frameworks
PUBLIC_HEADERS_DIR = $(PRODUCT_STATIC_LIBRARY_DIR)/Headers/$(MODULE_NAME)

XCODE = $(shell xcode-select -p)
OS_SDK = $(XCODE)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
SIMULATOR_SDK = $(XCODE)/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk

SOURCE_FILE_NAMES = IOPatternLockModel IOPointsModel IOCGRectUtilities IOPatternLockView
SOURCE_FILES = $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Models/IOPatternLockModel.m $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Models/IOPointsModel.m $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Utilities/IOCGRectUtilities.m $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Views/IOPatternLockView.m
OBJECT_FILES = $(addsuffix .o, $(SOURCE_FILE_NAMES))
ARM64_OBJECT_FILES = $(addprefix $(OBJECTS_ROOT_DIR)/arm64/, $(OBJECT_FILES))
ARMV7_OBJECT_FILES = $(addprefix $(OBJECTS_ROOT_DIR)/armv7/, $(OBJECT_FILES))
X86_OBJECT_FILES = $(addprefix $(OBJECTS_ROOT_DIR)/x86_64/, $(OBJECT_FILES))

HEADERS = IOPatternLock.h IOPatternLockDelegate.h IOPatternLockView.h
PUBLIC_HEADERS_SOURCE = $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/IOPatternLock.h $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Protocols/IOPatternLockDelegate.h $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Views/IOPatternLockView.h
PUBLIC_HEADERS = $(addprefix $(PUBLIC_HEADERS_DIR)/, $(HEADERS))
HEADER_SEARCH_PATHS = -I$(SOURCE_ROOT_DIR)/$(MODULE_NAME) \
	-I$(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Models -I$(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Utilities -I$(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Views \
	-I$(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Protocols

OS = $(shell uname)
Darwin_CLANG = clang
CLANG = $($(OS)_CLANG)

DEBUG.release = -g -Os -DRELEASE=1
DEBUG.debug = -g -O0 -DDEBUG=1
DEBUG := $(DEBUG.$(BUILD))

CLANG_FLAGS = $(DEBUG) -std=gnu11 -stdlib=libc++ -fobjc-arc -fobjc-weak -fobjc-abi-version=2 $(HEADER_SEARCH_PATHS)
COMPILER_FLAGS = -x objective-c $(CLANG_FLAGS)
LINKER_FLAGS = -static
FRAMEWORK_LINKER_FLAGS = -dynamiclib -mios-simulator-version-min=$(TARGET_SDK_VERSION) -Xlinker -rpath -Xlinker @executable_path/Frameworks \
	-Xlinker -rpath -Xlinker @loader_path/Frameworks -dead_strip -Xlinker -object_path_lto -Xlinker -export_dynamic \
	 -Xlinker -no_deduplicate -Xlinker -objc_abi_version -Xlinker 2 -fobjc-arc -fobjc-link-runtime \
	  -compatibility_version 1 -current_version 1 -Xlinker -dependency_info

all : prepareBuildDir $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME).a

clean:
	@rm -rf $(BUILD_ROOT_DIR)

$(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME).a: $(PUBLIC_HEADERS) $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_arm64.a  $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_armv7.a $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_x86_64.a
	lipo -create $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_arm64.a $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_armv7.a $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_x86_64.a -output $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME).a
	
$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME).framework: prepareBuildDirForFramework $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework/$(MODULE_NAME) $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework/$(MODULE_NAME) $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework/$(MODULE_NAME)
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME).framework
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME).framework/Headers
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME).framework/Modules
	@cp -r $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Info.plist $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME).framework
	@cp -r $(PRODUCT_FRAMEWORK_DIR)/module.modulemap $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME).framework/Modules
	$(CLANG) -arch x86_64 -isysroot $(OS_SDK) $(FRAMEWORK_LINKER_FLAGS) -install_name @rpath/$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework/$(MODULE_NAME) -c $(X86_OBJECT_FILES) -o $@
	@rm -rf $(PRODUCT_FRAMEWORK_DIR)/module.modulemap
	@chmod +x $@

prepareBuildDir:
	@mkdir -p $(SOURCE_ROOT_DIR)/Build
	@mkdir -p $(BUILD_ROOT_DIR)
	@mkdir -p $(OBJECTS_ROOT_DIR)
	@mkdir -p $(OBJECTS_ROOT_DIR)/x86_64
	@mkdir -p $(OBJECTS_ROOT_DIR)/arm64
	@mkdir -p $(OBJECTS_ROOT_DIR)/armv7
	@mkdir -p $(PRODUCT_STATIC_LIBRARY_DIR)
	@mkdir -p $(PRODUCT_STATIC_LIBRARY_DIR)/Headers
	@mkdir -p $(PUBLIC_HEADERS_DIR)
	
prepareBuildDirForFramework:
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)
	@rm -rf $(PRODUCT_FRAMEWORK_DIR)/module.modulemap
	@echo 'framework module IOPatternLock {\n\tumbrella header "IOPatternLock.h"\n\n\texport *\n\tmodule * { export * }\n}\n' > $(PRODUCT_FRAMEWORK_DIR)/module.modulemap
	
$(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_arm64.a: $(ARM64_OBJECT_FILES)
	libtool $(LINKER_FLAGS) -arch_only arm64 -syslibroot $(OS_SDK) $(ARM64_OBJECT_FILES) -o $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_arm64.a
	
$(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_armv7.a: $(ARMV7_OBJECT_FILES)
	libtool $(LINKER_FLAGS) -arch_only armv7 -syslibroot $(OS_SDK) $(ARMV7_OBJECT_FILES) -o $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_armv7.a
	
$(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_x86_64.a: $(X86_OBJECT_FILES)
	libtool $(LINKER_FLAGS) -arch_only x86_64 -syslibroot $(SIMULATOR_SDK) $(X86_OBJECT_FILES) -o $(PRODUCT_STATIC_LIBRARY_DIR)/lib$(MODULE_NAME)_x86_64.a

$(OBJECTS_ROOT_DIR)/arm64/%.o: $(SOURCE_FILES)
	$(CLANG) -x c -arch arm64 -isysroot $(OS_SDK) -miphoneos-version-min=$(TARGET_SDK_VERSION) $(COMPILER_FLAGS) -c $< -o $@
	
$(OBJECTS_ROOT_DIR)/armv7/%.o: $(SOURCE_FILES)
	$(CLANG) -x c -arch armv7 -isysroot $(OS_SDK) -miphoneos-version-min=$(TARGET_SDK_VERSION) $(COMPILER_FLAGS) -c $< -o $@
	
$(OBJECTS_ROOT_DIR)/x86_64/%.o: $(SOURCE_FILES)
	$(CLANG) -x c -arch x86_64 -isysroot $(SIMULATOR_SDK) -mios-simulator-version-min=$(TARGET_SDK_VERSION) $(COMPILER_FLAGS) -c $< -o $@
	
$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework/$(MODULE_NAME): $(ARM64_OBJECT_FILES)
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework/Headers
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework/Modules
	@cp -r $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Info.plist $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework
	@cp -r $(PRODUCT_FRAMEWORK_DIR)/module.modulemap $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework/Modules
	$(CLANG) -arch arm64 -isysroot $(OS_SDK) $(FRAMEWORK_LINKER_FLAGS) $(HEADER_SEARCH_PATHS) -install_name @rpath/$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework/$(MODULE_NAME) $(ARM64_OBJECT_FILES) -o $@
	@chmod +x $@
	
$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework/$(MODULE_NAME): $(ARMV7_OBJECT_FILES)
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework/Headers
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework/Modules
	@cp -r $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Info.plist $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework
	@cp -r $(PRODUCT_FRAMEWORK_DIR)/module.modulemap $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework/Modules
	$(CLANG) -arch armv7 -isysroot $(OS_SDK) $(FRAMEWORK_LINKER_FLAGS) $(HEADER_SEARCH_PATHS) -install_name @rpath/$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework/$(MODULE_NAME) $(ARMV7_OBJECT_FILES) -o $@
	@chmod +x $@
	
$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework/$(MODULE_NAME): $(X86_OBJECT_FILES)
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework/Headers
	@mkdir -p $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework/Modules
	@cp -r $(SOURCE_ROOT_DIR)/$(MODULE_NAME)/Info.plist $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework
	@cp -r $(PRODUCT_FRAMEWORK_DIR)/module.modulemap $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework/Modules
	$(CLANG) -arch x86_64 -isysroot $(SIMULATOR_SDK) $(FRAMEWORK_LINKER_FLAGS) $(HEADER_SEARCH_PATHS) -install_name @rpath/$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework/$(MODULE_NAME) $(X86_OBJECT_FILES) -o $@
	@chmod +x $@
	
$(PUBLIC_HEADERS_DIR)/%.h: $(PUBLIC_HEADERS_SOURCE)
	@cp -r $< $@
	
prepareFrameworkHeaders: $(addprefix $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework/Headers/, $(HEADERS)) $(addprefix $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework/Headers/, $(HEADERS)) $(addprefix $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework/Headers/, $(HEADERS)) $(addprefix $(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME).framework/Headers/, $(HEADERS))
	
$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_arm64.framework/Headers/%h: $(PUBLIC_HEADERS_SOURCE)
	@cp -r $< $@
	
$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_armv7.framework/Headers/%h: $(PUBLIC_HEADERS_SOURCE)
	@cp -r $< $@
	
$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME)_x86_64.framework/Headers/%h: $(PUBLIC_HEADERS_SOURCE)
	@cp -r $< $@
	
$(PRODUCT_FRAMEWORK_DIR)/$(MODULE_NAME).framework/Headers/%h: $(PUBLIC_HEADERS_SOURCE)
	@cp -r $< $@

.PHONY: all clean
	