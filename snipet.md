# 1. Duovoc に関するメモ

<!-- TOC -->

- [1. Duovoc に関するメモ](#1-duovoc-に関するメモ)
  - [1.1. 製品構成](#11-製品構成)
  - [1.2. Flavor の作り方](#12-flavor-の作り方)
  - [1.3. Flavor 毎にアプリアイコンを設定する方法](#13-flavor-毎にアプリアイコンを設定する方法)
  - [1.4. デバッグでの起動方法](#14-デバッグでの起動方法)
    - [1.4.1. Free](#141-free)
    - [1.4.2. Paid](#142-paid)
  - [1.5. リリースバンドルの作成方法](#15-リリースバンドルの作成方法)
    - [1.5.1. Free](#151-free)
    - [1.5.2. Paid](#152-paid)
  - [1.6. AdMob アプリケーション ID](#16-admob-アプリケーション-id)

<!-- /TOC -->

## 1.1. 製品構成

以下の製品を Flavor を使用して同じプロジェクト内で管理する。

| 製品名 | 区分 | 最新バージョン |
| ------ | ---- | -------------- |
| Duovoc | Free | 1.0.0          |
| Duovoc | Paid | 1.0.0          |

## 1.2. Flavor の作り方

`pubspec.yaml` に定義を追加し以下のコマンドを実行する。

```terminal
flutter pub run flutter_flavorizr
```

## 1.3. Flavor 毎にアプリアイコンを設定する方法

ルートに `flutter_launcher_icons-&{flavorName}.yaml` を追加し以下のコマンドを実行する。

```terminal
flutter pub run flutter_launcher_icons:main
```

## 1.4. デバッグでの起動方法

### 1.4.1. Free

| コマンド                                        | 備考                |
| ----------------------------------------------- | ------------------- |
| flutter run --flavor free -t lib/main-free.dart | Duovoc のフリー版。 |

### 1.4.2. Paid

| コマンド                                        | 備考              |
| ----------------------------------------------- | ----------------- |
| flutter run --flavor paid -t lib/main-paid.dart | Duovoc の有料版。 |

## 1.5. リリースバンドルの作成方法

### 1.5.1. Free

| コマンド                                                    | 備考                |
| ----------------------------------------------------------- | ------------------- |
| flutter build appbundle --flavor free -t lib/main-free.dart | Duovoc のフリー版。 |

### 1.5.2. Paid

| コマンド                                                    | 備考              |
| ----------------------------------------------------------- | ----------------- |
| flutter build appbundle --flavor paid -t lib/main-paid.dart | Duovoc の有料版。 |

## 1.6. AdMob アプリケーション ID

| 製品   | アプリケーション ID |
| ------ | ------------------- |
| Duovoc | -                   |
