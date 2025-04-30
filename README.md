<p align="center">
    <img src="https://raw.githubusercontent.com/sourabhappdev/get_ui_state_package/dev/assets/logo.png" alt="Package Logo" height="150" />
</p>

<p align="center">
	<i>Built on top of <a href="https://pub.dev/packages/get" target="_blank">GetX</a> for effortless UI state handling</i>
</p>
<p align="center">
	<a href="https://pub.dev/packages/get_ui_state_package" target="_blank"><img src="https://img.shields.io/pub/v/get_ui_state_package.svg" alt="Pub Version"></a>
	<a href="https://github.com/sourabhappdev/get_ui_state_package/actions" target="_blank"><img src="https://github.com/sourabhappdev/get_ui_state_package/workflows/build/badge.svg" alt="Build Status"></a>
	<a href="https://opensource.org/licenses/MIT" target="_blank"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License"></a>
	<a href="https://flutter.dev" target="_blank"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Platform"></a>
</p>

---

# get_ui_state_package

A lightweight and powerful Flutter package built on top of GetX that simplifies managing UI states such as:

- 🟡 Loading
- ✅ Success
- ❌ Error
- 📭 Empty
- 🟢 Initial

It helps you avoid boilerplate by providing a reactive and customizable way to handle common UI flows with retry and global configuration support.

---

## 🚀 Features

- Reactive `UiStateModel<T>` to wrap your data
- `UiStateBuilder` widget to handle all states easily
- Global configuration with per-widget override support
- Retry support
- Built-in `fromFuture()` and `fromStream()` helpers

---

## 🛠 Installation

```yaml
flutter pub add get_ui_state_package
```

---

## 📦 Import

```dart
import 'package:get_ui_state_package/get_ui_state_package.dart';
```

---

## 🌍 Global Setup (main.dart)

```dart
void main() {
  GlobalUiStateConfig.initialize(
    initialWidget: const Center(child: Text("🚀 Welcome")),
    loadingWidget: const Center(child: CircularProgressIndicator()),
    emptyWidget: const Center(child: Text("📭 No data to show")),
    errorBuilder: (context, error) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error.toString()),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Retry"),
          ),
        ],
      ),
    ),
  );

  runApp(const MyApp());
}
```

---

## 💡 Basic Example

```dart
class ExampleController extends GetxController {
  final state = UiStateModel<String>.initial().obs;

  void loadData() async {
    state.value = UiStateModel.loading();
    await Future.delayed(const Duration(seconds: 2));
    state.value = UiStateModel.success("Data Loaded");
  }
}

class ExampleScreen extends StatelessWidget {
  final controller = Get.put(ExampleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get UI State")),
      body: UiStateBuilder<String>(
        uiStateModel: controller.state,
        builder: (context, data) => Center(child: Text(data)),
        isRetry: true,
        retryFunction: controller.loadData,
      ),
    );
  }
}
```

---

## ⚡ Async Helpers

```dart
final stateFromFuture = UiStateModel<String>.fromFuture(myFuture());
final stateFromStream = UiStateModel<int>.fromStream(myStream());
```

---

## 📃 License

Licensed under the [MIT License](https://opensource.org/licenses/MIT)

---

## ❤️ Contribute

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

GitHub → [https://github.com/sourabhappdev/get_ui_state_package/tree/dev](https://github.com/sourabhappdev/get_ui_state_package/tree/dev)

---

### 📋 Copy Full Example

<pre>
<code>
class ExampleController extends GetxController {
  final state = UiStateModel.initial().obs;

  void loadData() async {
    state.value = UiStateModel.loading();
    await Future.delayed(const Duration(seconds: 2));
    state.value = UiStateModel.success("Data Loaded");
  }
}

class ExampleScreen extends StatelessWidget {
  final controller = Get.put(ExampleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get UI State")),
      body: UiStateBuilder(
        uiStateModel: controller.state,
        builder: (context, data) => Center(child: Text(data)),
        isRetry: true,
        retryFunction: controller.loadData,
      ),
    );
  }
}
</code>
</pre>
