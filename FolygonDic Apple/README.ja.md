# <img src="https://github.com/zolotayautka/FolygonDic/blob/main/FolygonDic/Assets.xcassets/AppIcon.appiconset/icon.png" width="30"> FolygonDic

**自ら言葉を記入して学習する単語帳アプリ**

## 主な機能

### 📝 単語管理
- **単語の追加/修正/削除**: 学習したい単語を自由に登録
- **品詞別分類**: 助詞、前置詞、名詞、動詞、形容詞、副詞、その他の7つの品詞に分類
- **多重フィールド対応**: 単語、漢字、意味、備考項目を含む詳細情報を保存
- **リアルタイム検索**: 単語、意味、漢字、備考など全てのフィールドから検索可能

### 🎯 学習機能
- **音声再生(TTS)**: 登録された単語を選択した言語で発音を聞くことができる
- **学習回数追跡**: 各単語ごとの学習回数を自動的に記録
- **毎日通知**: 毎日正午に学習通知を受け取ることができる
- **学習統計**: 円グラフで品詞別単語数を可視化

### ⌚ Apple Watch連動
- iPhoneから学習する単語をWatchへ送信
- Watchで学習した内容をiPhoneへ同期
- 学習記録の自動更新

### 🌍 多言語対応
- **韓国語** (ko)
- **日本語** (ja)
- **英語** (en)
- **ロシア語** (ru)
- **スペイン語** (es)
- **中国語** (zh)
- 学習言語別にカスタマイズされたTTS音声サポート

### 💾 データ管理
- SQLiteベースのローカルデータベース
- オフラインでも完全動作
- 安定的なデータ保存と管理

### 📱 マルチプラットフォーム
- **iOS** - iPhone最適化UI
- **iPadOS** - タブレット用Split View対応
- **macOS** - デスクトップ環境対応
- **watchOS** - Apple Watchアプリ提供

## 技術スタック
- **言語**: Swift, SwiftUI
- **データベース**: SQLite3
- **フレームワーク**: AVFoundation (TTS), UserNotifications, WatchConnectivity
- **最小要件**: iOS 14.0+

## App Store
https://apps.apple.com/jp/app/folygondic/id6754223204

---

**Language / 言語 / 언어**  
[한국어](README.ko.md) | 日本語 | [English](README.md)
