import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show MethodChannel, MethodCall, PlatformException;

class Wear {
  static const MethodChannel _channel = MethodChannel('wear');

  factory Wear() => instance;

  static final instance = Wear._();

  Wear._() {
    _channel.setMethodCallHandler(_onMethodCallHandler);
  }

  final _ambientCallbacks = <AmbientCallback>[];

  /// Register callback for ambient notifications
  void registerAmbientCallback(AmbientCallback callback) {
    _ambientCallbacks.add(callback);
  }

  /// Unregister callback for ambient notifications
  void unregisterAmbientCallback(AmbientCallback callback) {
    _ambientCallbacks.remove(callback);
  }

  Future<dynamic> _onMethodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onEnterAmbient':
        final args = (call.arguments as Map).cast<String, bool>();
        final details = AmbientDetails(args['burnInProtection']!, args['lowBitAmbient']!);
        _notifyAmbientCallbacks((callback) => callback.onEnterAmbient(details));
        break;
      case 'onExitAmbient':
        _notifyAmbientCallbacks((callback) => callback.onExitAmbient());
        break;
      case 'onUpdateAmbient':
        _notifyAmbientCallbacks((callback) => callback.onUpdateAmbient());
        break;
      case 'onInvalidateAmbientOffload':
        _notifyAmbientCallbacks((callback) => callback.onInvalidateAmbientOffload());
        break;
    }
  }

  void _notifyAmbientCallbacks(Function(AmbientCallback callback) fn) {
    final callbacks = List<AmbientCallback>.from(_ambientCallbacks);
    for (final callback in callbacks) {
      try {
        fn(callback);
      } catch (e, st) {
        debugPrint('Failed callback: $callback\n$e\n$st');
      }
    }
  }

  /// Fetches the shape of the watch face
  Future<String> getShape() async {
    try {
      return (await _channel.invokeMethod<String>('getShape'))!;
    } on PlatformException catch (e, st) {
      // Default to round
      debugPrint('Error calling getShape: $e\n$st');
      return 'round';
    }
  }

  /// Tells the application if we are currently in ambient mode
  Future<bool> isAmbient() async {
    try {
      return (await _channel.invokeMethod<bool>('isAmbient'))!;
    } on PlatformException catch (e, st) {
      debugPrint('Error calling isAmbient: $e\n$st');
      return false;
    }
  }

  /// Sets whether this activity's task should be moved to the front when
  /// the system exits ambient mode.
  ///
  /// If true, the activity's task may be moved to the front if it was the
  /// last activity to be running when ambient started, depending on how
  /// much time the system spent in ambient mode.
  ///
  Future<void> setAutoResumeEnabled(bool enabled) async {
    try {
      await _channel.invokeMethod<String>(
        'setAutoResumeEnabled',
        {'enabled': enabled},
      );
    } on PlatformException catch (e, st) {
      debugPrint('Error calling setAutoResumeEnabled: $e\n$st');
      rethrow;
    }
  }

  /// Sets whether this activity is currently in a state that supports ambient offload mode.
  Future<void> setAmbientOffloadEnabled(bool enabled) async {
    try {
      await _channel.invokeMethod<String>(
        'setAmbientOffloadEnabled',
        {'enabled': enabled},
      );
    } on PlatformException catch (e, st) {
      debugPrint('Error calling setAmbientOffloadEnabled: $e\n$st');
      rethrow;
    }
  }
}

/// Provides details of current ambient mode configuration.
class AmbientDetails {
  const AmbientDetails(this.burnInProtection, this.lowBitAmbient);

  /// Used to indicate whether burn-in protection is required.
  ///
  /// When this property is set to true, views must be shifted around
  /// periodically in ambient mode. To ensure that content isn't
  /// shifted off the screen, avoid placing content within 10 pixels
  /// of the edge of the screen. Activities should also avoid solid
  /// white areas to prevent pixel burn-in. Both of these
  /// requirements only apply in ambient mode, and only when
  /// this property is set to true.
  final bool burnInProtection;

  /// Used to indicate whether the device has low-bit ambient mode.
  ///
  /// When this property is set to true, the screen supports fewer bits
  /// for each color in ambient mode. In this case, activities should
  /// disable anti-aliasing in ambient mode.
  final bool lowBitAmbient;
}

/// Callback to receive ambient mode state changes.
abstract class AmbientCallback {
  /// Called when an activity is entering ambient mode.
  void onEnterAmbient(AmbientDetails ambientDetails) {}

  /// Called when an activity should exit ambient mode.
  void onExitAmbient() {}

  /// Called when the system is updating the display for ambient mode.
  void onUpdateAmbient() {}

  /// Called to inform an activity that whatever decomposition it has sent to
  /// Sidekick is no longer valid and should be re-sent before enabling ambient offload.
  void onInvalidateAmbientOffload() {}
}
