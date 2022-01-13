# 1.0.0

- Null Safety Migration (Finally!)
  - Thanks to Rexios and Peter Ullrich.
  - Min Dart 2.12 / Flutter 2.5 
- Updated native component versions:
  - Gradle 6.5
  - Android Gradle Plugin 4.1.0 
  - Android compileSdkVersion 31
  - AndroidX Wear 1.2.0
  - Kotlin 1.5.10
  - Removed `jcenter()` repo requirement.

# 0.1.1

- Fix Kotlin/Android compileOnly dep on com.google.android.wearable:wearable.

# 0.1.0

- Updated to AndroidX and Android embedding v2.
- Renamed `Shape` is now `WearShape`.
- Renamed `Mode` is now `WearMode`.
- Deprecated `InheritedShape`.
  _Add `WatchShape` instead and use `WatchShape.of(context)` to get the shape value._

# 0.0.1

- Initial release
