# Flutter Wear Plugin

A collection of widgets for developing Wear OS (Android Wear) apps in Flutter.

# Widgets

There currently three widgets provided by the plugin:

* WatchShape: determines whether the watch is square or round.
* InheritedShape: an InheritedWidget that can be used to pass the shape of the watch down the widget tree.
* AmbientMode: builder that provides what mode the watch is in. The widget will rebuild whenever the watch changes mode.

## Example

Typically all three of these widgets would be used near the root of your app's widget tree:

```dart
class WatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => WatchShape(
      builder: (context, shape) => InheritedShape(
          shape: shape,
          child: AmbientMode(
            builder: (context, mode) =>
                mode == Mode.active ? ActiveWatchFace() : AmbientWatchFace(),
          )));
}
```

# Requirements

## App Gradle File

Change the min SDK version to API 23:

```
minSdkVersion 23
```

Then, add the following dependencies to the Android Gradle file for the app:

```
dependencies {
    // Wear libraries
    implementation 'androidx.wear:wear:1.0.0'
    implementation 'com.google.android.support:wearable:2.7.0'
    compileOnly 'com.google.android.wearable:wearable:2.7.0'
}
```

## Manifest File

Add the following to your AndroidManifest.xml file:

```xml
<!-- Required for ambient mode support -->
<uses-permission android:name="android.permission.WAKE_LOCK" />

<!-- Flags the app as a Wear app -->
<uses-feature android:name="android.hardware.type.watch" />

<!-- Flags that the app doesn't require a companion phone app -->
<application>
    <meta-data
        android:name="com.google.android.wearable.standalone"
        android:value="true" />
</application>
```

## Update Android's MainActivity

The ambient mode widget needs some initialization in Android's MainActivity code, and MainActivity needs to extend `FlutterFragmentActivity`. Update your code as follows:

```kotlin
class MainActivity : FlutterFragmentActivity(), AmbientModeSupport.AmbientCallbackProvider {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    override fun getAmbientCallback(): AmbientModeSupport.AmbientCallback {
        return FlutterAmbientCallback(getChannel(flutterEngine))
    }
}
```
