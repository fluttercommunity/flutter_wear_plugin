# Flutter Wear Plugin

A plugin that offers Flutter support for Wear OS by Google (Android Wear).

__To use this plugin you must set your `minSdkVersion` to `23`.__


# Tutorial

https://medium.com/flutter-community/flutter-building-wearos-app-fedf0f06d1b4


# Widgets

There currently three widgets provided by the plugin:

* WatchShape: determines whether the watch is square or round.
* AmbientMode: builder that provides what mode the watch is in. The widget will rebuild whenever the watch changes mode.


## Example

Typically, all three of these widgets would be used near the root of your app's widget tree:

```dart
class WatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (BuildContext context, WearShape shape, Widget? child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return mode == Mode.active ? ActiveWatchFace() : AmbientWatchFace();
          },
        );
      },
    );
  }
}
```

# Old Requirements

**You DO NOT need to modify these files anymore:**

You can remove all the old wearable references from the previous release. This plugin
automatically adds all required references and settings.

1. `build.gradle`: _wearable dependencies_

2. `AndroidManifest.xml`: _`WAKE_LOCK` and `android.hardware.type.watch`
   and `com.google.android.wearable.standalone`._

3. `MainActivity.kt` or `MainActivity.java`: _all `AmbientMode` references._

