#!/bin/sh
export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate
if [ "${PLATFORM_NAME}" == "iphoneos" ]; then
	/Users/jasonmac/Desktop/gen_entitlements.py "my.company.${PROJECT_NAME}" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/${PROJECT_NAME}.xcent";
	codesign -f -s "iPhone Developers" --resource-rules "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/ResourceRules.plist" \
		 --entitlements "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/${PROJECT_NAME}.xcent"  "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/"
fi

