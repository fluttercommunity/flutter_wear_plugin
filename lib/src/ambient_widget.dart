import 'package:flutter/material.dart';
import 'package:wear/src/wear.dart';

/// Ambient modes for a Wear device
enum WearMode { active, ambient }

/// Builds a child for [AmbientMode]
typedef Widget AmbientModeWidgetBuilder(BuildContext context, WearMode mode, Widget? child);

/// Widget that listens for when a Wear device enters full power or ambient mode,
/// and provides this in a builder. It optionally takes an [onUpdate] function that's
/// called every time the wear device triggers an ambient update request.
@immutable
class AmbientMode extends StatefulWidget {
  const AmbientMode({
    Key? key,
    required this.builder,
    this.child,
    this.onUpdate,
  }) : super(key: key);

  final AmbientModeWidgetBuilder builder;
  final Widget? child;

  /// Called each time the the wear device triggers an ambient update request.
  final VoidCallback? onUpdate;

  /// Get current [WearMode].
  static WearMode wearModeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedAmbientMode>()!.mode;
  }

  /// Get current [AmbientDetails].
  static AmbientDetails ambientDetailsOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedAmbientMode>()!.details;
  }

  @override
  _AmbientModeState createState() => _AmbientModeState();
}

class _AmbientModeState extends State<AmbientMode> with AmbientCallback {
  var _ambientMode = WearMode.active;
  var _ambientDetails = AmbientDetails(false, false);

  @override
  void initState() {
    super.initState();
    Wear.instance.registerAmbientCallback(this);
    Wear.instance.isAmbient().then(_updateMode);
  }

  @override
  void dispose() {
    Wear.instance.unregisterAmbientCallback(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedAmbientMode(
      mode: _ambientMode,
      details: _ambientDetails,
      child: Builder(
        builder: (BuildContext context) {
          return widget.builder(context, _ambientMode, widget.child);
        },
      ),
    );
  }

  void _updateMode(bool isAmbient) {
    if (mounted) {
      setState(() => _ambientMode = isAmbient ? WearMode.ambient : WearMode.active);
    }
  }

  @override
  void onEnterAmbient(AmbientDetails ambientDetails) => _updateMode(true);

  @override
  void onExitAmbient() => _updateMode(false);

  @override
  void onUpdateAmbient() {
    _updateMode(true);
    widget.onUpdate?.call();
  }
}

class _InheritedAmbientMode extends InheritedWidget {
  const _InheritedAmbientMode({
    Key? key,
    required this.mode,
    required this.details,
    required Widget child,
  }) : super(key: key, child: child);

  final WearMode mode;
  final AmbientDetails details;

  @override
  bool updateShouldNotify(_InheritedAmbientMode old) {
    return mode != old.mode || details != old.details;
  }
}
