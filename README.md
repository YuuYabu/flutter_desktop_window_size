# Flutter on Desktopでウィンドウサイズを扱う話

## Qiita記事

https://qiita.com/yuu_yabu/items/36baa8651b9812f19d06

## 環境

Flutter 3.24.4 • channel stable • https://github.com/flutter/flutter.git  
Tools • Dart 3.5.4 • DevTools 2.37.3

## 使用パッケージ

window_manager ^0.4.3

## 起動までの手順

### fvmの導入

Windowsの場合、Chocolateyかdartを使って導入する。

```shell-session
# Chocolateyの場合
# 0. Chocolatey未導入の場合
$ Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
$ choco -v
# 1. fvmをインストール
$ choco install fvm

# dartの場合
$ dart pub global activate fvm
```

macOSの場合、brewかdartを使って導入する。

```shell-session
$ brew tap leoafarias/fvm
$ brew install fvm
```

### 指定したバージョンのFlutterを使用

```shell-session
$ fvm install 3.24.4
$ fvm use 3.24.4
```

### 使用パッケージを導入

```shell-session
$ fvm flutter pub get
```

### 起動

```shell-session
# Windows
$ fvm flutter run -d windows

# macOS
$ fvm flutter run -d macOS
```
