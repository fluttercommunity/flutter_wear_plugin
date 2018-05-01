import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

const MethodChannel _channel = const MethodChannel('wear');

class Wear {
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

/// Shape of a Wear device
enum Shape { square, round }

/// Ambient modes for a Wear device
enum Mode { active, ambient }

/// An inherited widget that holds the shape of the Watch
class InheritedShape extends InheritedWidget {
  const InheritedShape({Key key, @required this.shape, @required Widget child})
      : assert(shape != null),
        assert(child != null),
        super(key: key, child: child);

  final Shape shape;

  static InheritedShape of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedShape);
  }

  @override
  bool updateShouldNotify(InheritedShape old) => shape != old.shape;
}

/// Builds a child for a WatchFaceBuilder
typedef Widget WatchShapeBuilder(
  BuildContext context,
  Shape shape,
);

/// Builder widget for watch shapes
class WatchShape extends StatefulWidget {
  WatchShape({Key key, @required this.builder})
      : assert(builder != null),
        super(key: key);
  final WatchShapeBuilder builder;

  @override
  createState() => _WatchShapeState();
}

class _WatchShapeState extends State<WatchShape> {
  Shape shape;

  @override
  initState() {
    super.initState();
    // Default to round until the platform returns the shape
    // round being the most common form factor for WearOS
    shape = Shape.round;
    _setShape();
  }

  /// Sets the watch face shape
  _setShape() async {
    shape = await _getShape();
    setState(() => shape);
  }

  /// Fetches the shape of the watch face
  Future<Shape> _getShape() async {
    try {
      final int result = await _channel.invokeMethod('getShape');
      return result == 1 ? Shape.square : Shape.round;
    } on PlatformException catch (e) {
      // Default to round
      debugPrint('Error detecting shape: $e');
      return Shape.round;
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, shape);
}

/// Builds a child for AmbientModeBuilder
typedef Widget AmbientModeWidgetBuilder(
  BuildContext context,
  Mode mode,
);

/// Widget that listens for when a Wear device enters full power or ambient mode,
/// and provides this in a builder. It optionally takes an update function that's
/// called every time the watch triggers an ambient update request. If an update
/// function is passed in, this widget will not perform an update itself.
class AmbientMode extends StatefulWidget {
  AmbientMode({Key key, @required this.builder, this.update})
      : assert(builder != null),
        super(key: key);
  final AmbientModeWidgetBuilder builder;
  final Function update;

  @override
  createState() => _AmbientModeState();
}

class _AmbientModeState extends State<AmbientMode> {
  var ambientMode = Mode.active;

  @override
  initState() {
    super.initState();

    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case 'enter':
          setState(() => ambientMode = Mode.ambient);
          break;
        case 'update':
          if (widget.update != null)
            widget.update();
          else
            setState(() => ambientMode = Mode.ambient);
          break;
        case 'exit':
          setState(() => ambientMode = Mode.active);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, ambientMode);
}
