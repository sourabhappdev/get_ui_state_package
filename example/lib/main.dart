import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ui_state_package/get_ui_state_package.dart';

void main() {
  GlobalUiStateConfig.initialize(
    initialWidget: const Center(child: Text("App initializing...")),
    loadingWidget: const Center(child: CircularProgressIndicator()),
    emptyWidget: const Center(child: Text("No data found")),
    errorBuilder: (context, error) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: GlobalUiStateConfig.retryFunction,
            child: const Text("Retry"),
          ),
        ],
      ),
    ),
    isRetry: true,
    retryFunction: () => Get.find<HomeController>().fetchData(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX UI State Demo',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(title: const Text('UI State Example')),
      body: Column(
        children: [
          Expanded(
            child: UiStateBuilder<String>(
              uiStateModel: controller.uiStateModel,
              builder: (context, data) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.fetchData,
                      child: const Text("Reload"),
                    ),
                  ],
                ),
              ),
              initialOverride: const Center(child: Text("🚀 Welcome")),
              loadingOverride: const Center(child: CircularProgressIndicator()),
              emptyOverride: const Center(child: Text("📭 No data to show")),
              errorBuilderOverride: (context, error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("❌ $error", style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: controller.fetchData,
                      child: const Text("Retry Again"),
                    ),
                  ],
                ),
              ),
              isRetry: true,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("📦 From Future", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  UiStateBuilder<String>(
                    uiStateModel: controller.futureState,
                    builder: (context, data) => Center(child: Text(data)),
                    isRetry: true,
                    retryFunction: controller.retryFuture,
                    initialOverride:
                        const Center(child: Text("Initial Future State")),
                    loadingOverride:
                        const Center(child: CircularProgressIndicator()),
                    emptyOverride:
                        const Center(child: Text("No data from future")),
                    errorBuilderOverride: (context, error) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("❌ $error",
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: controller.retryFuture,
                          child: const Text("Retry Future"),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 40),
                  const Text("📶 From Stream", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  UiStateBuilder<String>(
                    uiStateModel: controller.streamState,
                    builder: (context, data) => Center(child: Text(data)),
                    initialOverride:
                        const Center(child: Text("Initial Stream State")),
                    loadingOverride:
                        const Center(child: CircularProgressIndicator()),
                    emptyOverride:
                        const Center(child: Text("No data from stream")),
                    errorBuilderOverride: (context, error) =>
                        Text("⚠️ Stream Error: $error"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
