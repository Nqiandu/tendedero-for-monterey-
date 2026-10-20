# Tendedero · macOS 12 兼容版

> Screenshots, hung out to dry.
>
> 每一张截图，都像晾衣服一样挂在屏幕顶端的细线上。

这是 [Alejandro Buján](https://github.com/alejandrobujan) 原作 [Tendedero](https://github.com/alejandrobujan/tendedero) 的 **macOS 12 (Monterey) 兼容移植版**。

原版需要 macOS 14 Sonoma 及以上，本仓库把所有 SwiftUI / Concurrency 新 API 降级改写，让 2018 款 Intel Mac（macOS 12）也能用上这个小工具。

---

## 它是什么？

每次截屏后，截图不会在右下角弹个碍事的缩略图，也不会堆在桌面上——而是直接挂在屏幕最顶端的一根细线上，像晾衣服一样。

- **单击**截图 → 复制到剪贴板
- **双击**截图 → 在「预览」里打开
- **长按**截图 → 在系统标记（Markup）里编辑
- **拖拽**截图 → 直接拖进正在用的文档 / 聊天框 / 文件夹
- **Force Touch** → Quick Look 快速预览
- **把指针停在菜单栏** → 晾衣绳滑下来
- **⌃⌥T** → 唤出 / 收起晾衣绳

截的屏不经过桌面，直接存进 Tendedero 自己的文件夹。拖出去一份就保留，点叉就丢弃。桌面终于干净了。

---

## 功能

- [x] 自动捕捉新截图，挂到顶部晾衣绳
- [x] 拖拽到任意 app / 文件夹
- [x] 单击复制、双击打开、长按标记
- [x] 屏幕录制也能挂着，带播放按钮
- [x] 剪贴板图片挂绳（可选开启）
- [x] 多文件夹监控
- [x] 自定义截图保留数量、卡片大小
- [x] 全局快捷键
- [x] **中英文界面切换**（菜单栏 → Language）
- [x] 完全离线，不联网，不上传

---

## 系统要求

- macOS 12.0 (Monterey) 或更高
- Intel / Apple Silicon 都可以（本仓库默认编译 x86_64）
- Xcode Command Line Tools

---

## 从源码编译

```bash
git clone https://github.com/你的用户名/tendedero-mac12.git
cd tendedero-mac12

# 编译二进制
swiftc -O \
  -target x86_64-apple-macosx12.0 \
  -framework AppKit -framework Carbon -framework Combine \
  -framework Quartz -framework ServiceManagement -framework SwiftUI \
  -framework AVFoundation \
  Sources/Tendedero/*.swift \
  -o Tendedero

# 打包成 .app
mkdir -p Tendedero.app/Contents/MacOS Tendedero.app/Contents/Resources
cp Tendedero Tendedero.app/Contents/MacOS/
cp -R Sources/Tendedero/Resources/*.lproj Tendedero.app/Contents/Resources/

# 生成图标
swift scripts/make-icon.swift icon.png
# 然后用 sips + iconutil 转成 icns 放进 Resources

# 写入 Info.plist（参考下方模板）
# ...

# ad hoc 签名
codesign --force --deep --sign - Tendedero.app
open Tendedero.app
```

### Info.plist 最小模板

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>Tendedero</string>
  <key>CFBundleDisplayName</key><string>Tendedero</string>
  <key>CFBundleIdentifier</key><string>app.tendedero.Tendedero</string>
  <key>CFBundleExecutable</key><string>Tendedero</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.6.0-mac12</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>12.0</string>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
```

---

## 跟原版的差异

| 项目 | 原版 (macOS 14+) | 本仓库 (macOS 12+) |
|---|---|---|
| 最低系统 | macOS 14 Sonoma | macOS 12 Monterey |
| Swift 工具链 | 5.9+ | 5.6+ |
| 开机自启 | `SMAppService` 自动注册 | 菜单里勾选后需手动去系统设置添加登录项 |
| 语言切换 | 跟随系统 | 菜单栏手动切英文 / 简体中文 |
| 截图动画 | 原版全部保留 | 原版全部保留 |

核心体验完全一致：晾衣绳、玻璃框、夹子、摆动、飘落动画——都在。

---

## 致谢

- 原作：**Alejandro Buján** — [@alejandrobujan](https://github.com/alejandrobujan) / [tendedero.app](https://tendedero.app)
- 图标和设计全部来自原作者，本仓库只做了兼容性移植

---

## License

代码部分遵循 **MIT License**（与原版一致）。

⚠️ 注意：原作者明确声明 **Tendedero 这个名字和图标不包含在 MIT 协议内**。如果你要二次发布或改名，请自己换个名字和图标。

---

## 截图

> （待补）
