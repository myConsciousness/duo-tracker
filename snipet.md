# 1. Duo Tracker に関するメモ

<!-- TOC -->

- [1. Duo Tracker に関するメモ](#1-duo-tracker-に関するメモ)
  - [1.1. 製品構成](#11-製品構成)
  - [1.2. Flavor の作り方](#12-flavor-の作り方)
  - [1.3. Flavor 毎にアプリアイコンを設定する方法](#13-flavor-毎にアプリアイコンを設定する方法)
  - [1.4. スプラッシュ画面の作成](#14-スプラッシュ画面の作成)
  - [1.5. インポートの自動ソート](#15-インポートの自動ソート)
  - [1.6. デバッグでの起動方法](#16-デバッグでの起動方法)
    - [1.6.1. Free](#161-free)
    - [1.6.2. Paid](#162-paid)
  - [1.7. リリースバンドルの作成方法](#17-リリースバンドルの作成方法)
    - [1.7.1. Free](#171-free)
    - [1.7.2. Paid](#172-paid)
  - [1.8. AdMob アプリケーション ID](#18-admob-アプリケーション-id)

<!-- /TOC -->

## 1.1. 製品構成

以下の製品を Flavor を使用して同じプロジェクト内で管理する。

| 製品名      | 区分 | 最新バージョン |
| ----------- | ---- | -------------- |
| Duo Tracker | Free | 1.2.8          |
| Duo Tracker | Paid | 1.2.8          |

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

## 1.4. スプラッシュ画面の作成

```terminal
flutter pub pub run flutter_native_splash:create
```

## 1.5. インポートの自動ソート

```terminal
flutter pub run import_sorter:main
```

## 1.6. デバッグでの起動方法

### 1.6.1. Free

| コマンド                                        | 備考                     |
| ----------------------------------------------- | ------------------------ |
| flutter run --flavor free -t lib/main_free.dart | Duo Tracker のフリー版。 |

### 1.6.2. Paid

| コマンド                                        | 備考                   |
| ----------------------------------------------- | ---------------------- |
| flutter run --flavor paid -t lib/main_paid.dart | Duo Tracker の有料版。 |

## 1.7. リリースバンドルの作成方法

### 1.7.1. Free

| コマンド                                                    | 備考                     |
| ----------------------------------------------------------- | ------------------------ |
| flutter build appbundle --flavor free -t lib/main_free.dart | Duo Tracker のフリー版。 |

### 1.7.2. Paid

| コマンド                                                    | 備考                   |
| ----------------------------------------------------------- | ---------------------- |
| flutter build appbundle --flavor paid -t lib/main_paid.dart | Duo Tracker の有料版。 |

## 1.8. AdMob アプリケーション ID

| 製品        | アプリケーション ID                    |
| ----------- | -------------------------------------- |
| Duo Tracker | ca-app-pub-7168775731316469~8366223064 |
