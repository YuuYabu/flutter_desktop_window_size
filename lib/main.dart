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
      home: LayoutForWindows(
          child: Center(
        child: Text('Hello World!'),
      )),
    );
  }
}

class LayoutForWindows extends StatefulWidget {
  final Widget child;
  const LayoutForWindows({super.key, required this.child});

  @override
  State<LayoutForWindows> createState() => _LayoutForWindowsState();
}

class _LayoutForWindowsState extends State<LayoutForWindows> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Windowsのデフォルトアプリでは半径7.5になっているので合わせる
      borderRadius: const BorderRadius.all(Radius.circular(7.5)),
      // ドラッグしてウィンドウのサイズを調整できる範囲を指定
      child: DragToResizeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 1,
                // ドラッグしてウィンドウを移動できる範囲を指定
                child: DragToMoveArea(
                  // タイトルバー代わりのContainer
                  child: Container(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 最小化
                        IconButton(
                            onPressed: () {
                              windowManager.minimize();
                            },
                            icon: const Icon(Icons.minimize)),
                        // 最大化・戻す
                        IconButton(
                            onPressed: () async {
                              bool isMaximized =
                                  await windowManager.isMaximized();
                              if (isMaximized) {
                                windowManager.unmaximize();
                              } else {
                                windowManager.maximize();
                              }
                            },
                            icon: const Icon(Icons.rectangle_outlined)),
                        // 閉じる
                        IconButton(
                            onPressed: () {
                              windowManager.close();
                            },
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 19,
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
