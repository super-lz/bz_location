# bz_location

`bz_location` 是基于 `amap_flutter_location 3.0.0` 迁移出来的自有 Flutter 插件，已按 Flutter `3.38.10` 创建新的 pub 工程并保留原定位能力模型。

## 设计定位

- 保留高德定位 Flutter 插件的 `MethodChannel` / `EventChannel` 模型。
- 保留多实例 `pluginKey` 机制。
- 适配 `bz_location` 包名和 Flutter 3.38.10 插件骨架。

## 参考基线

- pub 基线：`amap_flutter_location 3.0.0`
- 官方兼容性文档说明：Flutter 插件 `3.0.0` 基于 Android 定位 `5.6.0`、iOS 定位 `2.8.0`，适配对应版本及以上
- 官方文档入口：
  - <https://pub.dev/packages/amap_flutter_location>
  - <https://lbs.amap.com/api/flutter/guide/positioning-flutter-plug-in/positioning-compatibility>
  - <https://lbs.amap.com/api/flutter/guide/positioning-flutter-plug-in/integration-location-flutter-plugin>

## 接入说明

1. 申请高德 Android / iOS 定位 Key。
2. Android 宿主工程引入高德定位 SDK。
3. iOS 宿主工程通过 CocoaPods 引入 `AMapLocation`。
4. 在调用定位前先调用隐私合规接口：
   - `AMapFlutterLocation.updatePrivacyShow(...)`
   - `AMapFlutterLocation.updatePrivacyAgree(...)`
5. 设置 Key、配置 `AMapLocationOption`，再开始定位。

## 最小示例

```dart
final plugin = AMapFlutterLocation();
AMapFlutterLocation.updatePrivacyShow(true, true);
AMapFlutterLocation.updatePrivacyAgree(true);
AMapFlutterLocation.setApiKey('your-android-key', 'your-ios-key');
plugin.setLocationOption(AMapLocationOption(onceLocation: true));
plugin.startLocation();
```

## 说明

- 当前实现以兼容高德原插件 API 为主，便于你继续按业务需要做二次封装。
- `flutter analyze` 仍会报告一批历史风格提示，但核心编译错误已清理，单测可通过。
