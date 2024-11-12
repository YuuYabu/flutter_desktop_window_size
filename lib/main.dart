import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // 初期化
  WidgetsFlutterBinding.ensureInitialized();

  // window_managerを初期化
  windowManager.ensureInitialized();
  // ウィンドウプロパティを指定
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    center: true,
  );

  // ウィンドウを表示
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAsFrameless();
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
