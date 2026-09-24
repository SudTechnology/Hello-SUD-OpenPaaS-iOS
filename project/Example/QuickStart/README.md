[English](README_en.md)

# QuickStart

## 环境要求

- iOS 15.0 及以上
- Xcode 和 CocoaPods

## 安装与运行

在仓库根目录执行：

```bash
cd project/Example/QuickStart
pod install --repo-update
open QuickStart.xcworkspace
```

在 Xcode 中选择 `QuickStart` Scheme 和模拟器或真机运行。真机运行前，请配置自己的开发团队与签名。

## SDK 依赖

当前 Podfile 使用 CocoaPods 官方 GitHub Specs 源，接入已发布的远程版本：

```ruby
source 'https://github.com/CocoaPods/Specs.git'

# 以下声明位于 QuickStart target 内。
pod 'SUDGI', '2.1.0'
pod 'SUDM/admob', '2.1.0'
```

`SUDCoreKit` 由 `SUDGI` 自动引入；`SUDM/admob` 还会引入 `SUDCoreKit`、`SUDReport` 和 Google Mobile Ads SDK，无需重复声明基础组件。

`SUDOPWrappedClientKit` 是示例使用的本地包装层，继续保留：

```ruby
pod 'SUDOPWrappedClientKit', :path => '../../SUDOPWrappedClientKit/'
```

需要调试本地 SDK 时，取消 Podfile 中四条本地 SDK 依赖的注释，同时注释两条远程 SDK 依赖，再执行 `pod install`。同一 SDK 的本地和远程声明不要同时启用。

完整宿主集成说明见[仓库 README](../../../README.md)。

## 参考文档

[开发文档](https://ifzx25dxpkx57hb6.sud.tech/)
