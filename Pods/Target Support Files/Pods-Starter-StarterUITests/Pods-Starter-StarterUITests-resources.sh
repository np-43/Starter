#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR

if [ -z ${UNLOCALIZED_RESOURCES_FOLDER_PATH+x} ]; then
  # If UNLOCALIZED_RESOURCES_FOLDER_PATH is not set, then there's nowhere for us to copy
  # resources to, so exit 0 (signalling the script phase was successful).
  exit 0
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")

case "${TARGETED_DEVICE_FAMILY:-}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\"" || true
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH" || true
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/af.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ar.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/bn.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ckb_IQ.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/cs.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/da.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/de.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/el.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/en.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/en_GB.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/es.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/es_ES.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/fi.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/fr.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/gu.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/he.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/hi.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/hr.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/hu.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/id.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/it.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/iw.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ja.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ko.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ml.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/mr.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ms.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/my.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/my_MM.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/nb.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/nl.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/pa.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/pl.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/pt.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/pt_PT.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ro.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ru.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/sk.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/sv.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/sw.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/sw_KE.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ta.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/te.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/th.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/tl.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/tr.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ur.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ur_PK.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/vi.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/zh.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/zh_Hant_HK.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/zh_Hant_TW.lproj"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/af.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ar.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/bn.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ckb_IQ.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/cs.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/da.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/de.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/el.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/en.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/en_GB.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/es.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/es_ES.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/fi.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/fr.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/gu.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/he.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/hi.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/hr.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/hu.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/id.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/it.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/iw.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ja.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ko.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ml.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/mr.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ms.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/my.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/my_MM.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/nb.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/nl.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/pa.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/pl.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/pt.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/pt_PT.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ro.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ru.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/sk.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/sv.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/sw.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/sw_KE.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ta.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/te.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/th.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/tl.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/tr.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ur.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/ur_PK.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/vi.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/zh.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/zh_Hant_HK.lproj"
  install_resource "${PODS_ROOT}/AccountKit/AccountKit.framework/AccountKitStrings.bundle/Resources/zh_Hant_TW.lproj"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "${XCASSET_FILES:-}" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find -L "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  if [ -z ${ASSETCATALOG_COMPILER_APPICON_NAME+x} ]; then
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  else
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${TARGET_TEMP_DIR}/assetcatalog_generated_info_cocoapods.plist"
  fi
fi
