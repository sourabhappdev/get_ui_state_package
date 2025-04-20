import '../constants/enum_constants.dart';
import 'package:get/get.dart';

final class UiStateModel<T> {
  UiStateModel._({required this.state, T? data, String? error})
      : _data = data,
        _error = error;

  factory UiStateModel.initial() => UiStateModel._(state: UiState.initial);
  factory UiStateModel.loading() => UiStateModel._(state: UiState.loading);
  factory UiStateModel.success(T data) =>
      UiStateModel._(state: UiState.success, data: data);
  factory UiStateModel.empty() => UiStateModel._(state: UiState.empty);
  factory UiStateModel.error(String error) =>
      UiStateModel._(state: UiState.error, error: error);

  final UiState state;
  final T? _data;
  final String? _error;

  T get data {
    assert(state == UiState.success, 'Data only available in success state.');
    return _data!;
  }

  String get error {
    assert(state == UiState.error, 'Error only available in error state.');
    return _error!;
  }

  static Future<void> fromFuture<T>({
    required Future<T> future,
    required Rx<UiStateModel<T>> rxModel,
    String Function(Object error)? onError,
    bool Function(T data)? isEmpty,
  }) async {
    rxModel.value = UiStateModel.loading();
    try {
      final data = await future;
      if (isEmpty != null && isEmpty(data)) {
        rxModel.value = UiStateModel.empty();
      } else {
        rxModel.value = UiStateModel.success(data);
      }
    } catch (e) {
      rxModel.value = UiStateModel.error(onError?.call(e) ?? e.toString());
    }
  }

  static void fromStream<T>({
    required Stream<T> stream,
    required Rx<UiStateModel<T>> rxModel,
    String Function(Object error)? onError,
    bool Function(T data)? isEmpty,
  }) {
    rxModel.value = UiStateModel.loading();
    stream.listen(
      (data) {
        if (isEmpty != null && isEmpty(data)) {
          rxModel.value = UiStateModel.empty();
        } else {
          rxModel.value = UiStateModel.success(data);
        }
      },
      onError: (e) {
        rxModel.value = UiStateModel.error(onError?.call(e) ?? e.toString());
      },
    );
  }
}
