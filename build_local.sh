#!/bin/bash
# build_local.sh Build Elite IPA Info Info Info Info (Info)
# Info: bash build_local.sh
set -e

echo "==> Install XcodeGen Info Info"
command -v xcodegen >/dev/null 2>&1 || brew install xcodegen

echo "==> Info Info zsign"
[ -d zsign ] || git clone --depth 1 https://github.com/zhlynn/zsign.git zsign

echo "==> Generate Info Xcode"
xcodegen generate

echo "==> Build Info Info Sign"
xcodebuild \
 -project EliteIPA.xcodeproj \
 -scheme EliteIPA \
 -configuration Release \
 -sdk iphoneos \
 -derivedDataPath build \
 CODE_SIGN_IDENTITY="" \
 CODE_SIGNING_REQUIRED=NO \
 CODE_SIGNING_ALLOWED=NO \
 clean build

echo "==> Package Info IPA"
rm -rf Payload EliteIPA.ipa
mkdir -p Payload
cp -r build/Build/Products/Release-iphoneos/EliteIPA.app Payload/
zip -r EliteIPA.ipa Payload
echo "==> Done: EliteIPA.ipa Ready"
