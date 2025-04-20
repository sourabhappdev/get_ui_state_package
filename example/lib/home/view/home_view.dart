import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ui_state_package/get_ui_state_package.dart';


import '../controller/home_controller.dart';





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
              // Optional overrides
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
                    initialOverride: const Center(child: Text("Initial Future State")),
                    loadingOverride: const Center(child: CircularProgressIndicator()),
                    emptyOverride: const Center(child: Text("No data from future")),
                    errorBuilderOverride: (context, error) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("❌ $error", style: const TextStyle(color: Colors.red)),
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
                    initialOverride: const Center(child: Text("Initial Stream State")),
                    loadingOverride: const Center(child: CircularProgressIndicator()),
                    emptyOverride: const Center(child: Text("No data from stream")),
                    errorBuilderOverride: (context, error) => Text("⚠️ Stream Error: $error"),
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


