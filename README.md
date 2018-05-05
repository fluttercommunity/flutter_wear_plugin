# Wear

A collection of widgets for developing Wear OS (Android Wear) apps.

# Widgets

There currently three widgets provided by the plugin:

## WatchShape

Determines whether the watch is square or round.

## InheritedShape

An InheritedWidget that can be used to pass the shape of the watch down the widget tree.

## AmbientMode

A builder that provides what mode the watch is in. The widget will rebuild whenever the watch changes mode.

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
