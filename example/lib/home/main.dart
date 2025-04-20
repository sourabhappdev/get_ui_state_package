import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ui_state_package/get_ui_state_package.dart';
import 'package:get_ui_state_package_example/home/view/home_view.dart';


import 'controller/home_controller.dart';




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
