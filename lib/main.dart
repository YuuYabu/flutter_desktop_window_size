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
    backgroundColor: Colors.transparent,
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
      home: ClipRRect(
        // Windowsのデフォルトアプリでは半径7.5になっているので合わせる
        borderRadius: BorderRadius.all(Radius.circular(7.5)),
        // ドラッグしてウィンドウのサイズを調整できる範囲を指定
        child: DragToResizeArea(
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  // Windows風のタイトルバーとウィンドウコントロールを追加
                  child: WindowCaption(
                    title: Text(
                      'test',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                ),
                Expanded(
                  flex: 19,
                  child: Center(
                    child: Text('Hello World!'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
