# FolygonDic (PC版)

**Qtで構築されたクロスプラットフォーム対応デスクトップ単語学習アプリ**

## 概要

FolygonDic PCは、自分だけの単語帳を作成して学習できるデスクトップ単語学習アプリケーションです。Qtフレームワークで構築され、Windows、macOS、Linuxプラットフォームでネイティブなデスクトップ体験を提供します。

## 主な機能

### 📝 単語管理
- **単語の追加/修正/削除**: 学習したい単語を自由に登録
- **品詞別分類**: 6つの品詞に分類:
  - 助詞/前置詞（言語に応じて調整可能）
  - 名詞
  - 動詞
  - 形容詞
  - 副詞
  - その他
- **多重フィールド対応**: 単語、漢字、意味、備考項目を含む詳細情報を保存
- **リアルタイム検索**: 単語、意味、漢字、備考など全てのフィールドから検索可能

### 🎯 学習機能
- **音声再生(TTS)**: 
  - macOS: 言語別音声を使用したネイティブ`say`コマンド
  - Windows: Microsoft音声を使用したSystem.Speech.Synthesis
  - Linux: `espeak`または`festival` TTSエンジン
- **学習回数追跡**: 各単語ごとの学習回数を自動的に記録
- **学習モード**: 進捗追跡機能付きフラッシュカード形式の学習インターフェース
- **学習統計**: Qt Chartsを使用して品詞別単語数を円グラフで可視化

### 🌍 多言語対応
- **韓国語** (ko)
- **日本語** (ja)
- **英語** (en)
- システムロケールからの自動言語検出
- 学習言語別にカスタマイズされたTTS音声サポート

### 💾 データ管理
- `~/Dictionary`に保存されるSQLiteベースのローカルデータベース
- オフラインでも完全動作
- 安定的なデータ保存と管理
- 組み込みSQLite3エンジンを含む

### 🖥️ クロスプラットフォーム対応
- **Windows** - フルWindowsデスクトップサポート
- **macOS** - ネイティブmacOS体験
- **Linux** - 主要なLinuxディストリビューションと互換性

## 技術スタック

- **フレームワーク**: Qt 5/6 (Qt Core, Qt Gui, Qt Widgets, Qt Charts)
- **言語**: C++ (C++11以降)
- **データベース**: SQLite3 (組み込み)
- **UI**: Qt Designer (.uiファイル)
- **ビルドシステム**: qmake (.proファイル)

## ソースからのビルド

### 前提条件

- Qt 5.xまたはQt 6.x開発ライブラリ
- C++11互換コンパイラ
- CMakeまたはqmake

### ビルド手順

1. リポジトリをクローン:
```bash
git clone https://github.com/yourusername/FolygonDic.git
cd FolygonDic/FolygonDic\ Pc/
```

2. qmakeでビルド:
```bash
qmake FolygonDic.pro
make
```

3. アプリケーションを実行:
```bash
./FolygonDic
```

## プロジェクト構造

```
FolygonDic Pc/
├── main.cpp              # アプリケーションエントリポイント
├── mainqt.cpp/h/ui       # メインウィンドウ実装
├── folygonkire.cpp/h     # コア辞書機能
├── add_kotoba.cpp/h/ui   # 単語追加ダイアログ
├── modify_kotoba.cpp/h/ui # 単語編集ダイアログ
├── new_dic.cpp/h/ui      # 新規辞書作成ダイアログ
├── study.cpp/h/ui        # 学習モード実装
├── sqlite3.c/h           # SQLite3データベースエンジン
├── FolygonDic.pro        # Qtプロジェクトファイル
├── *.ts, *.qm            # 翻訳ファイル (ja, ko, en)
└── imgs/                 # アプリケーションリソース
    └── lisence.txt       # アイコンライセンス情報
```

## ライセンス

本プログラムはフリーソフトウェアです。Free Software Foundationが公開する**GNU Lesser General Public License (LGPL)** バージョン3またはそれ以降のバージョンの条件に基づいて、再配布および/または修正することができます。

本プログラムは有用であることを願って配布されていますが、**いかなる保証もありません**。商品性や特定目的への適合性の黙示的保証すらありません。詳細はGNU Lesser General Public Licenseをご覧ください。

本プログラムと共にGNU Lesser General Public Licenseのコピーを受け取っているはずです。もし受け取っていない場合は、<http://www.gnu.org/licenses/>をご覧ください。

### Qtフレームワークライセンス

本アプリケーションは**Qtフレームワーク**を使用しており、複数のライセンスで利用可能です:
- **LGPL v3** (本プロジェクトで使用)
- 商用ライセンス

LGPL v3の下でQtを使用する場合、以下が必要です:
- アプリケーションのソースコードを提供する（配布する場合）
- ユーザーが異なるバージョンのQtでアプリケーションを再リンクできるようにする
- Qtのライセンス情報を含める

Qtライセンスの詳細については、https://www.qt.io/licensing/ をご覧ください。

### サードパーティライセンス

#### アイコン
本アプリケーションで使用されているアイコンは**Feather Icons**から提供されており、**MITライセンス**の下でライセンスされています:

```
Copyright (c) 2013-2023 Cole Bemis
Copyright (c) 2013-2023 Feather Icons (https://feathericons.com/)

以下に定める条件に従い、本ソフトウェアおよび関連文書のファイル（以下「ソフトウェア」）
の複製を取得するすべての人に対し、ソフトウェアを無制限に扱うことを無償で許可します。
これには、ソフトウェアの複製を使用、複写、変更、結合、掲載、頒布、サブライセンス、
および/または販売する権利、およびソフトウェアを提供する相手に同じことを許可する権利も
無制限に含まれます。

上記の著作権表示および本許諾表示を、ソフトウェアのすべての複製または重要な部分に
記載するものとします。
```

完全なアイコンライセンスの詳細については、[imgs/lisence.txt](imgs/lisence.txt)をご覧ください。

#### SQLite
本アプリケーションにはSQLite3 (sqlite3.c/h)が含まれており、**パブリックドメイン**です。

## 作者

Copyright (C) 2024 Shin Sukju

## 関連プロジェクト

- [FolygonDic Apple](../FolygonDic%20Apple/) - Swift/SwiftUIで構築されたiOS/macOS/watchOS版
- App Store: https://apps.apple.com/jp/app/folygondic/id6754223204

---

**Language / 言語 / 언어**  
[English](README.md) | 日本語 | [한국어](README.ko.md)
