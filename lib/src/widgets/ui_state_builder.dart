import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/ui_state_model.dart';

import '../constants/enum_constants.dart';
import '../utils/global_ui_config.dart';

/// A reactive widget that listens to [UiStateModel] and updates UI accordingly.
/// It supports global fallback widgets and optional per-screen overrides.
final class UiStateBuilder<T> extends StatelessWidget {
  const UiStateBuilder({
    required this.uiStateModel,
    required this.builder,
    this.initialOverride,
    this.loadingOverride,
    this.emptyOverride,
    this.errorBuilderOverride,
    this.isRetry = false,
    this.retryFunction,
    super.key,
  });

  /// The reactive state to observe
  final Rx<UiStateModel<T>> uiStateModel;

  /// The builder function to build UI when state is success
  final Widget Function(BuildContext context, T data) builder;

  /// Optional widget to override global initial widget
  final Widget? initialOverride;

  /// Optional widget to override global loading widget
  final Widget? loadingOverride;

  /// Optional widget to override global empty widget
  final Widget? emptyOverride;

  /// Optional error widget builder to override global error widget
  final Widget Function(BuildContext context, String error)?
  errorBuilderOverride;

  /// Whether to show retry button for this screen
  final bool isRetry;

  /// Retry callback for this specific screen
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
