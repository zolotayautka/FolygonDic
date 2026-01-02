# <img src="https://github.com/zolotayautka/FolygonDic/blob/main/FolygonDic/Assets.xcassets/AppIcon.appiconset/icon.png" width="30"> FolygonDic

**A vocabulary learning application where you can create and study your own word lists - Available on Apple platforms and PC**

FolygonDic is a comprehensive vocabulary learning application available in two versions:
- **Apple Version**: iOS, iPadOS, macOS, and watchOS
- **PC Version**: Windows, macOS, and Linux desktop

## 📱 Apple Version

Available on the App Store for iPhone, iPad, Mac, and Apple Watch.

**[Download on App Store](https://apps.apple.com/jp/app/folygondic/id6754223204)**

### Key Features
- **Multi-platform**: iOS, iPadOS, macOS, watchOS
- **Apple Watch Integration**: Send and sync study words between iPhone and Watch
- **Daily Notifications**: Study reminders every day at noon
- **Native Experience**: Built with Swift and SwiftUI
- **7 Parts of Speech**: Particle, preposition, noun, verb, adjective, adverb, and others

### Tech Stack
- Swift, SwiftUI
- SQLite3 database
- AVFoundation (TTS), UserNotifications, WatchConnectivity
- Minimum: iOS 14.0+

**[Learn more about Apple version →](FolygonDic%20Apple/README.md)**

---

## 🖥️ PC Version

Cross-platform desktop application built with Qt framework.

### Key Features
- **Cross-platform**: Windows, macOS, Linux
- **Qt Framework**: Native desktop experience on all platforms
- **Offline-first**: SQLite database stored locally
- **Multi-language TTS**: Platform-specific text-to-speech support
- **6 Parts of Speech**: Particle/Preposition, noun, verb, adjective, adverb, and others

### Tech Stack
- C++ (C++11)
- Qt 5/6 (Qt Core, Gui, Widgets, Charts)
- SQLite3 (embedded)
- qmake build system

**[Learn more about PC version →](FolygonDic%20Pc/README.md)**

---

## 🌟 Common Features

Both versions share core functionality:

### 📝 Word Management
- Add, edit, and delete vocabulary entries
- Part of speech classification
- Multi-field support: word, kanji, meaning, notes
- Real-time search across all fields

### 🎯 Learning Features
- **Text-to-Speech (TTS)**: Listen to pronunciation in your selected language
- **Study Count Tracking**: Automatic recording of study progress
- **Study Mode**: Flashcard-style learning interface
- **Learning Statistics**: Visualize progress with charts

### 🌍 Multilingual Support
- Korean (ko)
- Japanese (ja)
- English (en)
- Language-specific TTS voices

### 💾 Data Management
- SQLite-based local database
- Fully offline functionality
- Reliable data storage

---

## 📂 Repository Structure

```
FolygonDic/
├── FolygonDic Apple/     # iOS, macOS, watchOS version (Swift/SwiftUI)
│   ├── FolygonDic/       # Main iOS/macOS app
│   ├── FolygonDic Watch App/  # watchOS companion app
│   └── README.md         # Apple version documentation
│
└── FolygonDic Pc/        # Desktop version (C++/Qt)
    ├── *.cpp/h           # Source files
    ├── *.ui              # Qt Designer UI files
    ├── FolygonDic.pro    # Qt project file
    └── README.md         # PC version documentation
```

---

## 📄 License

### Apple Version
Copyright (C) 2024 Shin Sukju  
See [FolygonDic Apple](FolygonDic%20Apple/) for details.

### PC Version
This program is licensed under **GNU Lesser General Public License (LGPL) v3**.

#### Qt Framework
This application uses the Qt Framework under **LGPL v3** license.  
For more information: https://www.qt.io/licensing/

#### Third-Party Components
- **Icons**: Feather Icons (MIT License) (https://feathericons.com/)
- **SQLite**: Public Domain

See [FolygonDic Pc/imgs/lisence.txt](FolygonDic%20Pc/imgs/lisence.txt) for icon license details.

Full license information available in [FolygonDic Pc/README.md](FolygonDic%20Pc/README.md).

---

## 🌐 Documentation

**Language / 言語 / 언어**

### Main README
- English (current)
- [日本語](README.ja.md)
- [한국어](README.ko.md)

### Platform-specific Documentation
- **Apple Version**: [EN](FolygonDic%20Apple/README.md) | [JA](FolygonDic%20Apple/README.ja.md) | [KO](FolygonDic%20Apple/README.ko.md)
- **PC Version**: [EN](FolygonDic%20Pc/README.md) | [JA](FolygonDic%20Pc/README.ja.md) | [KO](FolygonDic%20Pc/README.ko.md)

---

## 👨‍💻 Author

**Shin Sukju**  
Copyright (C) 2024

---

## 🔗 Links

- **App Store**: https://apps.apple.com/jp/app/folygondic/id6754223204
- **Apple Version Docs**: [FolygonDic Apple/README.md](FolygonDic%20Apple/README.md)
- **PC Version Docs**: [FolygonDic Pc/README.md](FolygonDic%20Pc/README.md)
