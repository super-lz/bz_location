# bz_location

`bz_location` 是高德定位 Flutter 插件封装，提供单次定位、连续定位、定位参数配置和定位结果监听能力。适合需要在 Flutter 项目中获取当前位置的业务场景。

## 安装

在宿主工程的 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  bz_location:
    git:
      url: https://github.com/super-lz/bz_location.git
```

然后执行：

```bash
flutter pub get
```

## 高德 Key

高德定位 Key 需要按平台分别申请。

| 平台 | 高德开放平台配置 | 宿主工程配置 |
| --- | --- | --- |
| Android | 选择 Android 平台，填写包名和 SHA1 | 包名必须与 `applicationId` 一致 |
| iOS | 选择 iOS 平台，填写 Bundle ID | Bundle ID 必须与 Xcode 工程一致 |

Android 调试包和发布包通常使用不同签名。如果定位返回鉴权失败或长时间没有有效坐标，优先检查高德后台的调试版 SHA1、发布版 SHA1 和包名是否匹配。

## 平台配置

### Android

宿主工程需要声明定位相关权限。按业务需要保留最小权限集合：

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Android 6.0 及以上还需要在运行时申请定位权限。

### iOS

iOS 需要在 `ios/Runner/Info.plist` 中声明定位用途文案：

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>用于获取当前位置</string>
```

如果业务需要后台定位，还需要补充对应的后台定位权限和 Xcode Capability。

## 隐私合规

调用定位能力前，需要先完成高德隐私合规声明：

```dart
AMapFlutterLocation.updatePrivacyShow(true, true);
AMapFlutterLocation.updatePrivacyAgree(true);
```

建议在 App 启动后、创建定位实例前完成声明。

## 基础用法

```dart
final location = AMapFlutterLocation();

AMapFlutterLocation.updatePrivacyShow(true, true);
AMapFlutterLocation.updatePrivacyAgree(true);
AMapFlutterLocation.setApiKey(
  'your-android-key',
  'your-ios-key',
);

location.setLocationOption(
  AMapLocationOption(
    onceLocation: true,
    needAddress: true,
  ),
);

final subscription = location.onLocationChanged().listen((result) {
  final latitude = result['latitude'];
  final longitude = result['longitude'];
});

location.startLocation();
```

页面销毁时停止定位并释放监听：

```dart
location.stopLocation();
subscription.cancel();
location.destroy();
```

常见能力：

| 能力 | 入口 |
| --- | --- |
| 设置 Key | `AMapFlutterLocation.setApiKey` |
| 隐私声明 | `updatePrivacyShow` / `updatePrivacyAgree` |
| 设置定位参数 | `setLocationOption` |
| 开始定位 | `startLocation` |
| 停止定位 | `stopLocation` |
| 监听定位结果 | `onLocationChanged` |
| 释放实例 | `destroy` |

## iOS 模拟器

高德官方 iOS SDK 的 CocoaPods 包目前不能在 Apple Silicon iOS 模拟器上直接链接真实定位 SDK。真机不受这个限制。

可选调试方式：

| 场景 | 建议 |
| --- | --- |
| 调试真实定位 | 使用 iOS 真机 |
| 只调试 Flutter 页面和业务 UI | 启用模拟器占位模式 |
| 必须在模拟器尝试真实 SDK | 可尝试 Rosetta / x86_64 模拟器环境，但不保证可用 |

启用模拟器占位模式：

```bash
AMAP_IOS_SIMULATOR_STUBS=1 pod install
AMAP_IOS_SIMULATOR_STUBS=1 flutter run
```

切回真机真实定位：

```bash
pod install
flutter run
```

切换模式后建议清理并重新安装 iOS Pods，避免 Xcode 继续使用旧的构建产物：

```bash
rm -rf ios/Pods ios/Podfile.lock
pod install
```

占位模式只用于让 App 在 iOS 模拟器启动，不提供真实定位能力。需要验证定位精度、地址解析、连续定位等能力时，请使用真机。

## 注意事项

| 问题 | 排查方向 |
| --- | --- |
| Android 没有定位结果 | 检查 Key、包名、SHA1、系统定位开关、运行时权限 |
| iOS 没有定位结果 | 检查 Key、Bundle ID、Info.plist 定位文案、系统定位权限 |
| 返回坐标但没有地址 | 检查是否开启 `needAddress` |
| 连续定位耗电较高 | 页面不可见或业务结束时及时调用 `stopLocation` |
| 模拟器无法链接 iOS SDK | 使用模拟器占位模式或改用真机 |
