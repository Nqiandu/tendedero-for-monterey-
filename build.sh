#!/bin/bash
# Build Tendedero.app for macOS 12+ (Intel).
# Usage: ./build.sh
set -euo pipefail
cd "$(dirname "$0")"

APP="build/Tendedero.app"
VERSION="1.6.0-mac12"

mkdir -p build

echo "→ 编译二进制..."
swiftc -O \
  -target x86_64-apple-macosx12.0 \
  -framework AppKit -framework Carbon -framework Combine \
  -framework Quartz -framework ServiceManagement -framework SwiftUI \
  -framework AVFoundation \
  Sources/Tendedero/*.swift \
  -o build/Tendedero-bin

echo "→ 打包 .app..."
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp build/Tendedero-bin "$APP/Contents/MacOS/Tendedero"

# 翻译文件
for dir in Sources/Tendedero/Resources/*.lproj; do
  cp -R "$dir" "$APP/Contents/Resources/"
done

# 图标
echo "→ 生成图标..."
WORK=$(mktemp -d)
swift scripts/make-icon.swift "$WORK/icon.png"
ICONSET="$WORK/Tendedero.iconset"
mkdir -p "$ICONSET"
for s in 16 32 128 256 512; do
  sips -z $s $s "$WORK/icon.png" --out "$ICONSET/icon_${s}x${s}.png" >/dev/null
  sips -z $((s*2)) $((s*2)) "$WORK/icon.png" --out "$ICONSET/icon_${s}x${s}@2x.png" >/dev/null
done
iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/Tendedero.icns"
rm -rf "$WORK"

# Info.plist
cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>Tendedero</string>
  <key>CFBundleDisplayName</key><string>Tendedero</string>
  <key>CFBundleIdentifier</key><string>app.tendedero.Tendedero</string>
  <key>CFBundleExecutable</key><string>Tendedero</string>
  <key>CFBundleIconFile</key><string>Tendedero</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>${VERSION}</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>CFBundleDevelopmentRegion</key><string>en</string>
  <key>LSMinimumSystemVersion</key><string>12.0</string>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
  <key>NSDesktopFolderUsageDescription</key>
  <string>Tendedero watches the folder where macOS saves your screenshots so it can hang them on the line.</string>
</dict>
</plist>
PLIST

# 签名
echo "→ ad hoc 签名..."
codesign --force --deep --sign - "$APP" >/dev/null

echo ""
echo "✅ 完成！→ $APP"
echo "   双击打开即可，首次运行如果提示未受信任，右键 → 打开。"
