import 'package:flutter/material.dart';

/// A global configuration class for UI state widgets used in [UiStateBuilder].
///
/// This allows centralizing default widgets for:
/// - Initial state
/// - Loading state
/// - Empty state
/// - Error state
///
/// ✅ Must be initialized once in `main.dart` before any usage of [UiStateBuilder].
class GlobalUiStateConfig {
  static Widget? _initialWidget;
  static Widget? _loadingWidget;
  static Widget? _emptyWidget;
  static Widget Function(BuildContext context, String error)? _errorBuilder;
  static bool? _isRetry;
  static VoidCallback? _retryFunction;

  static bool _isInitialized = false;

  /// Returns whether the config has been initialized.
  static bool get isInitialized => _isInitialized;

  /// Initializes the global configuration.
  ///
  /// Must be called before using any widget depending on this config (e.g., [UiStateBuilder]).
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
    _isInitialized = true;
  }

  /// Validates whether all required widgets are initialized (used in debug only).
  static void assertInitialized() {
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

  /// Returns the global initial state widget.
  static Widget get initialWidget {
    assertInitialized();
    return _initialWidget!;
  }

  /// Returns the global loading state widget.
  static Widget get loadingWidget {
    assertInitialized();
    return _loadingWidget!;
  }

  /// Returns the global empty state widget.
  static Widget get emptyWidget {
    assertInitialized();
    return _emptyWidget!;
  }

  /// Returns the global error widget builder.
  static Widget Function(BuildContext context, String error) get errorBuilder {
    assertInitialized();
    return _errorBuilder!;
  }

  /// Returns whether retry should be globally enabled.
  static bool get isRetry => _isRetry ?? false;

  /// Returns the global retry function, if any.
  static VoidCallback? get retryFunction => _retryFunction;
}
