import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/ui_state_model.dart';
import '../constants/enum_constants.dart';
import '../utils/global_ui_config.dart';

/// A reactive widget that builds different UI states based on [UiStateModel].
///
/// This widget listens to a reactive [Rx<UiStateModel>] and renders one of the following states:
/// - `initial`: Shows a placeholder UI.
/// - `loading`: Shows a loading indicator.
/// - `empty`: Shows an empty state view.
/// - `success`: Shows the main UI using the [builder].
/// - `error`: Shows an error UI with optional retry.
///
/// It supports **global fallback widgets** configured via [GlobalUiStateConfig],
/// and also allows **per-instance overrides** for flexibility.
///
/// ⚠️ Make sure to call [GlobalUiStateConfig.initialize] in your `main.dart`
/// before using this widget, otherwise an assertion will fail.
final class UiStateBuilder<T> extends StatelessWidget {
  UiStateBuilder({
    required this.uiStateModel,
    required this.builder,
    this.initialOverride,
    this.loadingOverride,
    this.emptyOverride,
    this.errorBuilderOverride,
    this.isRetry = false,
    this.retryFunction,
    super.key,
  }) : assert(
         GlobalUiStateConfig.isInitialized,
         'GlobalUiStateConfig must be initialized in main.dart before using UiStateBuilder',
       );

  /// The reactive state model to observe.
  final Rx<UiStateModel<T>> uiStateModel;

  /// The builder function to construct the success UI when data is available.
  final Widget Function(BuildContext context, T data) builder;

  /// Optional widget to override the global initial state widget.
  final Widget? initialOverride;

  /// Optional widget to override the global loading state widget.
  final Widget? loadingOverride;

  /// Optional widget to override the global empty state widget.
  final Widget? emptyOverride;

  /// Optional error widget builder to override the global error builder.
  final Widget Function(BuildContext context, String error)?
  errorBuilderOverride;

  /// Whether to show a retry mechanism for this screen (optional, used with global retry config).
  final bool isRetry;

  /// Retry callback specific to this screen (overrides global retry if provided).
  final VoidCallback? retryFunction;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = uiStateModel.value.state;

      return switch (state) {
        UiState.initial => initialOverride ?? GlobalUiStateConfig.initialWidget,
        UiState.loading => loadingOverride ?? GlobalUiStateConfig.loadingWidget,
        UiState.empty => emptyOverride ?? GlobalUiStateConfig.emptyWidget,
        UiState.success => builder(context, uiStateModel.value.data),
        UiState.error => (errorBuilderOverride ??
            GlobalUiStateConfig.errorBuilder)(
          context,
          uiStateModel.value.error,
        ),
      };
    });
  }
}
