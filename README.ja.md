# <img src="https://github.com/zolotayautka/FolygonDic/blob/main/FolygonDic Apple/FolygonDic/Assets.xcassets/AppIcon.appiconset/icon.png" width="30"> FolygonDic

**自ら単語を記入して学習する単語帳アプリ - Appleプラットフォームおよびデスクトップ対応**

FolygonDicは2つのバージョンで利用可能な総合的な単語学習アプリケーションです:
- **Apple版**: iOS、iPadOS、macOS、watchOS
- **PC版**: Windows、macOS、Linuxデスクトップ

## 📱 Apple版

App StoreでiPhone、iPad、Mac、Apple Watch向けに配信中。

**[App Storeでダウンロード](https://apps.apple.com/jp/app/folygondic/id6754223204)**

### 主な機能
- **マルチプラットフォーム**: iOS、iPadOS、macOS、watchOS
- **Apple Watch連動**: iPhoneとWatchの間で学習単語を送信・同期
- **毎日通知**: 毎日正午に学習通知
- **ネイティブ体験**: SwiftとSwiftUIで構築
- **7つの品詞**: 助詞、前置詞、名詞、動詞、形容詞、副詞、その他

### 技術スタック
- Swift、SwiftUI
- SQLite3データベース
- AVFoundation (TTS)、UserNotifications、WatchConnectivity
- 最小要件: iOS 14.0+

**[Apple版の詳細 →](FolygonDic%20Apple/README.ja.md)**

---

## 🖥️ PC版

Qtフレームワークで構築されたクロスプラットフォームデスクトップアプリケーション。

### 主な機能
- **クロスプラットフォーム**: Windows、macOS、Linux
- **Qtフレームワーク**: 全プラットフォームでネイティブなデスクトップ体験
- **オフライン優先**: ローカルに保存されるSQLiteデータベース
- **多言語TTS**: 
  - macOS/Windows: プラットフォームネイティブのテキスト読み上げ
  - Linux: gTTS (Google Text-to-Speech) ライブラリ
- **6つの品詞**: 助詞/前置詞、名詞、動詞、形容詞、副詞、その他

### 技術スタック
- C++ (C++11)
- Qt 5/6 (Qt Core、Gui、Widgets、Charts)
- SQLite3 (組み込み)
- qmakeビルドシステム

**[PC版の詳細 →](FolygonDic%20Pc/README.ja.md)**

---

## 🌟 共通機能

両バージョンに共通するコア機能:

### 📝 単語管理
- 単語エントリの追加、編集、削除
- 品詞別分類
- 多重フィールド対応: 単語、漢字、意味、備考
- 全フィールドからのリアルタイム検索

### 🎯 学習機能
- **音声再生(TTS)**: 選択した言語で発音を聞くことができる
- **学習回数追跡**: 学習進捗の自動記録
- **学習モード**: フラッシュカード形式の学習インターフェース
- **学習統計**: チャートで進捗を可視化

### 🌍 多言語対応
- 韓国語 (ko)
- 日本語 (ja)
- 英語 (en)
- 言語別TTS音声

### 💾 データ管理
- SQLiteベースのローカルデータベース
- 完全なオフライン機能
- 安定的なデータ保存

---

## 📂 リポジトリ構造

```
FolygonDic/
├── FolygonDic Apple/     # iOS、macOS、watchOS版 (Swift/SwiftUI)
│   ├── FolygonDic/       # メインiOS/macOSアプリ
│   ├── FolygonDic Watch App/  # watchOSコンパニオンアプリ
│   └── README.md         # Apple版ドキュメント
│
└── FolygonDic Pc/        # デスクトップ版 (C++/Qt)
    ├── *.cpp/h           # ソースファイル
    ├── *.ui              # Qt Designer UIファイル
    ├── FolygonDic.pro    # Qtプロジェクトファイル
    └── README.md         # PC版ドキュメント
```

---

## 📄 ライセンス

### Apple版
Copyright (C) 2024 Shin Sukju  
詳細は[FolygonDic Apple](FolygonDic%20Apple/)をご覧ください。

### PC版
このプログラムは**GNU Lesser General Public License (LGPL) v3**の下でライセンスされています。

#### Qtフレームワーク
本アプリケーションは**LGPL v3**ライセンスの下でQtフレームワークを使用しています。  
詳細情報: https://www.qt.io/licensing/

#### サードパーティコンポーネント
- **アイコン**: Feather Icons (MITライセンス) (https://feathericons.com/)
- **SQLite**: パブリックドメイン
- **gTTS** (Linux専用): Google Text-to-Speechライブラリ (MITライセンス) (https://github.com/pndurette/gTTS)

アイコンライセンスの詳細は[FolygonDic Pc/imgs/lisence.txt](FolygonDic%20Pc/imgs/lisence.txt)をご覧ください。

##### Feather Iconsライセンス
本アプリケーションで使用されているアイコンは**Feather Icons**から提供されており、**MITライセンス**の下でライセンスされています:

```
Copyright (c) 2013-2023 Cole Bemis
Copyright (c) 2013-2023 Feather Icons (https://feathericons.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

詳細情報: https://feathericons.com/

##### gTTSライセンス (Linux専用)
PC版はLinuxでテキスト読み上げ機能のために**MITライセンス**の下でライセンスされた**gTTS**を使用します:

```
Copyright (c) 2014-2023 Pierre Nicolas Durette

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

詳細情報: https://github.com/pndurette/gTTS

完全なライセンス情報は[FolygonDic Pc/README.ja.md](FolygonDic%20Pc/README.ja.md)で確認できます。

---

## 🌐 ドキュメント

**Language / 言語 / 언어**

### メインREADME
- [English](README.md)
- 日本語 (現在)
- [한국어](README.ko.md)

### プラットフォーム別ドキュメント
- **Apple版**: [EN](FolygonDic%20Apple/README.md) | [JA](FolygonDic%20Apple/README.ja.md) | [KO](FolygonDic%20Apple/README.ko.md)
- **PC版**: [EN](FolygonDic%20Pc/README.md) | [JA](FolygonDic%20Pc/README.ja.md) | [KO](FolygonDic%20Pc/README.ko.md)

---

## 👨‍💻 作者

**Shin Sukju**  
Copyright (C) 2024

---

## 🔗 リンク

- **App Store**: https://apps.apple.com/jp/app/folygondic/id6754223204
- **Apple版ドキュメント**: [FolygonDic Apple/README.ja.md](FolygonDic%20Apple/README.ja.md)
- **PC版ドキュメント**: [FolygonDic Pc/README.ja.md](FolygonDic%20Pc/README.ja.md)
