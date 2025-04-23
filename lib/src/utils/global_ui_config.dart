import 'package:flutter/material.dart';

/// Global configuration for UI states.
/// Initialize this once in `main.dart` before using `UiStateBuilder`.
class GlobalUiStateConfig {
  static Widget? _initialWidget;
  static Widget? _loadingWidget;
  static Widget? _emptyWidget;
  static Widget Function(BuildContext context, String error)? _errorBuilder;
  static bool? _isRetry;
  static VoidCallback? _retryFunction;

  /// Must be called in `main.dart` before any usage of `UiStateBuilder`.
  static void initialize({
    required Widget initialWidget,
    required Widget loadingWidget,
    required Widget emptyWidget,
    required Widget Function(BuildContext context, String error) errorBuilder,
    bool isRetry = false,
    VoidCallback? retryFunction,
  }) {
    _initialWidget = initialWidget;
    _loadingWidget = loadingWidget;
    _emptyWidget = emptyWidget;
    _errorBuilder = errorBuilder;
    _isRetry = isRetry;
    _retryFunction = retryFunction;
  }

  /// Ensures that global config is initialized before use.
  static void _assertInitialized() {
    assert(
      _initialWidget != null,
      'Initial widget must be set in GlobalUiStateConfig.initialize()',
    );
    assert(
      _loadingWidget != null,
      'Loading widget must be set in GlobalUiStateConfig.initialize()',
    );
    assert(
      _emptyWidget != null,
      'Empty widget must be set in GlobalUiStateConfig.initialize()',
    );
    assert(
      _errorBuilder != null,
      'Error builder must be set in GlobalUiStateConfig.initialize()',
    );
  }

  /// Global getter methods (with assertions)
  static Widget get initialWidget {
    _assertInitialized();
    return _initialWidget!;
  }

  static Widget get loadingWidget {
    _assertInitialized();
    return _loadingWidget!;
  }

  static Widget get emptyWidget {
    _assertInitialized();
    return _emptyWidget!;
  }

  static Widget Function(BuildContext context, String error) get errorBuilder {
    _assertInitialized();
    return _errorBuilder!;
  }

  static bool get isRetry => _isRetry ?? false;

  static VoidCallback? get retryFunction => _retryFunction;
}
