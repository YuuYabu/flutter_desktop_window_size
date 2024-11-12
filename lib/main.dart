import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // 初期化
  WidgetsFlutterBinding.ensureInitialized();

  // window_managerを初期化
  windowManager.ensureInitialized();
  // ウィンドウプロパティを指定
  WindowOptions windowOptions = WindowOptions(
    size: const Size(1280, 720),
    backgroundColor: Colors.transparent,
    center: true,
    // ウィンドウのタイトル
    title: 'Flutterウィンドウサイズの話',
    // タイトルバーのスタイル、`normal`で通常表示、`hidden`で非表示
    // ウィンドウがフレームレスの場合、非表示される
    titleBarStyle: Platform.isMacOS ? TitleBarStyle.normal : null,
    // ウィンドウコントロールの表示、trueで表示
    // ウィンドウがフレームレスの場合、非表示される
    windowButtonVisibility: Platform.isMacOS ? true : null,
    // タスクバーで非表示にするかどうかの設定
    skipTaskbar: false,
  );

  // ウィンドウを表示
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Windowsの場合フレームレス化
    if (Platform.isWindows) await windowManager.setAsFrameless();
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget child = const Center(
      child: Text('Hello World!'),
    );
    return MaterialApp(
      home: Platform.isWindows
          ? LayoutForWindows(child: child)
          : LayoutForMacOS(child: child),
    );
  }
}

/// Windows向けのレイアウトを提供するウィジェット。
///
/// このウィジェットは、ウィンドウのドラッグやサイズ調整、
/// タイトルバー部分のボタン（最小化、最大化、閉じる）を備えた
/// Windowsデスクトップ風のUIを構築します。
///
/// - [child] は、ウィンドウの主要な内容を表示するウィジェットです。
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

/// macOS向けのレイアウトを提供するウィジェット。
///
/// このウィジェットは、macOSのデスクトップアプリケーションで使用するレイアウトを提供します。
/// Windowsのようなカスタムタイトルバーやウィンドウ操作ボタンは含まれていません。
///
/// - [child] は、ウィンドウの主要な内容を表示するウィジェットです。
class LayoutForMacOS extends StatefulWidget {
  final Widget child;
  const LayoutForMacOS({super.key, required this.child});

  @override
  State<LayoutForMacOS> createState() => _LayoutForMacOSState();
}

class _LayoutForMacOSState extends State<LayoutForMacOS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
    );
  }
}
