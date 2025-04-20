import 'package:get/get.dart';
import 'package:get_ui_state_package/get_ui_state_package.dart';

class HomeController extends GetxController {
  final Rx<UiStateModel<String>> uiStateModel =
  Rx<UiStateModel<String>>(UiStateModel.initial());
  final futureState = UiStateModel<String>.initial().obs;
  final streamState = UiStateModel<String>.initial().obs;

  Future<void> fetchData() async {
    uiStateModel.value = UiStateModel.loading();

    await Future.delayed(const Duration(seconds: 2));

    final result = await simulateApiCall();

    uiStateModel.value = result;
  }

  Future<UiStateModel<String>> simulateApiCall() async {
    final random = DateTime.now().second % 4;

    switch (random) {
      case 0:
        return UiStateModel.success("🎉 API Success: Data loaded");
      case 1:
        return UiStateModel.empty();
      case 2:
        return UiStateModel.error("Something went wrong!");
      default:
        return UiStateModel.success("✅ Default Success");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
    loadFromFuture();
    loadFromStream();
  }

  void loadFromFuture() async {
    futureState.value = UiStateModel.loading();
    try {
      await Future.delayed(const Duration(seconds: 2));
      futureState.value = UiStateModel.success("🎯 Data from Future");
    } catch (e) {
      futureState.value = UiStateModel.error(e.toString());
    }
  }

  void loadFromStream() {
    streamState.value = UiStateModel.loading();

    Stream<String> stream = Stream<String>.periodic(
      const Duration(seconds: 3),
          (count) => "🔁 Stream data #$count",
    ).take(1);

    stream.listen(
          (data) {
        streamState.value = UiStateModel.success(data);
      },
      onError: (error) {
        streamState.value = UiStateModel.error(error.toString());
      },
      onDone: () {
        if (streamState.value.state != UiState.success) {
          streamState.value = UiStateModel.empty();
        }
      },
    );
  }

  void retryFuture() {
    loadFromFuture();
  }

}
