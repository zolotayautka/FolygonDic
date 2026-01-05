# FolygonDic (PC Version)

**A cross-platform desktop vocabulary learning application built with Qt**

## Overview

FolygonDic PC is a desktop vocabulary learning application that allows you to create and study your own word lists. Built with Qt framework, it provides a native desktop experience on Windows, macOS, and Linux platforms.

## Key Features

### 📝 Word Management
- **Add/Edit/Delete Words**: Freely register words you want to learn
- **Part of Speech Classification**: Categorize into 6 parts of speech:
  - Particle/Preposition (adjustable based on language)
  - Noun
  - Verb
  - Adjective
  - Adverb
  - Others
- **Multi-field Support**: Store detailed information including word, kanji, meaning, and notes
- **Real-time Search**: Search across all fields including word, meaning, kanji, and notes

### 🎯 Learning Features
- **Text-to-Speech (TTS)**: 
  - macOS: Uses native `say` command with language-specific voices
  - Windows: Uses native System.Speech.Synthesis with Microsoft voices
  - Linux: Uses gTTS (Google Text-to-Speech) library for multi-language support
- **Study Count Tracking**: Automatically record the number of times each word has been studied
- **Study Mode**: Flashcard-style learning interface with progress tracking
- **Learning Statistics**: Visualize word count by part of speech with pie charts using Qt Charts

### 🌍 Multilingual Support
- **Korean** (ko)
- **Japanese** (ja)
- **English** (en)
- Automatic language detection from system locale
- Customized TTS voice support for each learning language

### 💾 Data Management
- SQLite-based local database stored in `~/Dictionary`
- Fully functional offline
- Reliable data storage and management
- Database includes embedded SQLite3 engine

### 🖥️ Cross-platform Support
- **Windows** - Full Windows desktop support
- **macOS** - Native macOS experience
- **Linux** - Compatible with major Linux distributions

## Tech Stack

- **Framework**: Qt 5/6 (Qt Core, Qt Gui, Qt Widgets, Qt Charts)
- **Language**: C++ (C++11 or later)
- **Database**: SQLite3 (embedded)
- **UI**: Qt Designer (.ui files)
- **Build System**: qmake (.pro file)

## Building from Source

### Prerequisites

- Qt 5.x or Qt 6.x development libraries
- C++11 compatible compiler
- CMake or qmake

### Build Instructions

1. Clone the repository:
```bash
git clone https://github.com/yourusername/FolygonDic.git
cd FolygonDic/FolygonDic\ Pc/
```

2. Build with qmake:
```bash
qmake FolygonDic.pro
make
```

3. Run the application:
```bash
./FolygonDic
```

## Project Structure

```
FolygonDic Pc/
├── main.cpp              # Application entry point
├── mainqt.cpp/h/ui       # Main window implementation
├── folygonkire.cpp/h     # Core dictionary functions
├── add_kotoba.cpp/h/ui   # Add word dialog
├── modify_kotoba.cpp/h/ui # Edit word dialog
├── new_dic.cpp/h/ui      # New dictionary creation dialog
├── study.cpp/h/ui        # Study mode implementation
├── sqlite3.c/h           # SQLite3 database engine
├── FolygonDic.pro        # Qt project file
├── *.ts, *.qm            # Translation files (ja, ko, en)
└── imgs/                 # Application resources
    └── lisence.txt       # Icon license information
```

## License

This program is free software: you can redistribute it and/or modify it under the terms of the **GNU Lesser General Public License (LGPL)** as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

### Qt Framework License

This application uses the **Qt Framework**, which is available under multiple licenses:
- **LGPL v3** (used in this project)
- Commercial License

When using Qt under LGPL v3, you must:
- Provide the source code of your application (if distributed)
- Allow users to re-link your application with different versions of Qt
- Include Qt's license information

For more information about Qt licensing, visit: https://www.qt.io/licensing/

### Third-Party Licenses

#### Icons
The icons used in this application are from **Feather Icons**, licensed under the **MIT License**:

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

See [imgs/lisence.txt](imgs/lisence.txt) for full icon license details.

#### SQLite
This application includes SQLite3 (sqlite3.c/h), which is in the **Public Domain**.

#### gTTS (Google Text-to-Speech)
On Linux, this application uses **gTTS** for text-to-speech functionality, licensed under the **MIT License**:

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

For more information: https://github.com/pndurette/gTTS

## Author

Copyright (C) 2024 Shin Sukju

## Related Projects

- [FolygonDic Apple](../FolygonDic%20Apple/) - iOS/macOS/watchOS version built with Swift/SwiftUI
- App Store: https://apps.apple.com/jp/app/folygondic/id6754223204

---

**Language / 言語 / 언어**  
English | [日本語](README.ja.md) | [한국어](README.ko.md)
