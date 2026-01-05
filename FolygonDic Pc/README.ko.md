# FolygonDic (PC 버전)

**Qt로 구축된 크로스 플랫폼 데스크톱 어휘 학습 애플리케이션**

## 개요

FolygonDic PC는 자신만의 단어장을 만들어 학습할 수 있는 데스크톱 어휘 학습 애플리케이션입니다. Qt 프레임워크로 구축되어 Windows, macOS, Linux 플랫폼에서 네이티브 데스크톱 경험을 제공합니다.

## 주요 기능

### 📝 단어 관리
- **단어 추가/수정/삭제**: 학습하고 싶은 단어를 자유롭게 등록
- **품사별 분류**: 6가지 품사로 분류:
  - 조사/전치사 (언어에 따라 조정 가능)
  - 명사
  - 동사
  - 형용사
  - 부사
  - 기타
- **다중 필드 지원**: 단어, 한자, 의미, 비고 항목을 포함한 상세 정보 저장
- **실시간 검색**: 단어, 의미, 한자, 비고 등 모든 필드에서 검색 가능

### 🎯 학습 기능
- **음성 재생(TTS)**: 
  - macOS: 언어별 음성을 사용한 네이티브 `say` 명령
  - Windows: Microsoft 음성을 사용한 네이티브 System.Speech.Synthesis
  - Linux: 다국어 지원을 위한 gTTS (Google Text-to-Speech) 라이브러리 사용
- **학습 횟수 추적**: 각 단어별 학습 횟수를 자동으로 기록
- **학습 모드**: 진행 상황 추적 기능이 있는 플래시카드 스타일 학습 인터페이스
- **학습 통계**: Qt Charts를 사용하여 품사별 단어 수를 파이 차트로 시각화

### 🌍 다국어 지원
- **한국어** (ko)
- **일본어** (ja)
- **영어** (en)
- 시스템 로케일에서 자동 언어 감지
- 학습 언어별 맞춤 TTS 음성 지원

### 💾 데이터 관리
- `~/Dictionary`에 저장되는 SQLite 기반 로컬 데이터베이스
- 오프라인에서도 완전 동작
- 안정적인 데이터 저장 및 관리
- 임베디드 SQLite3 엔진 포함

### 🖥️ 크로스 플랫폼 지원
- **Windows** - 전체 Windows 데스크톱 지원
- **macOS** - 네이티브 macOS 경험
- **Linux** - 주요 Linux 배포판과 호환

## 기술 스택

- **프레임워크**: Qt 5/6 (Qt Core, Qt Gui, Qt Widgets, Qt Charts)
- **언어**: C++ (C++11 이상)
- **데이터베이스**: SQLite3 (임베디드)
- **UI**: Qt Designer (.ui 파일)
- **빌드 시스템**: qmake (.pro 파일)

## 소스로부터 빌드

### 사전 요구사항

- Qt 5.x 또는 Qt 6.x 개발 라이브러리
- C++11 호환 컴파일러
- CMake 또는 qmake

### 빌드 방법

1. 리포지토리 클론:
```bash
git clone https://github.com/yourusername/FolygonDic.git
cd FolygonDic/FolygonDic\ Pc/
```

2. qmake로 빌드:
```bash
qmake FolygonDic.pro
make
```

3. 애플리케이션 실행:
```bash
./FolygonDic
```

## 프로젝트 구조

```
FolygonDic Pc/
├── main.cpp              # 애플리케이션 진입점
├── mainqt.cpp/h/ui       # 메인 윈도우 구현
├── folygonkire.cpp/h     # 핵심 사전 기능
├── add_kotoba.cpp/h/ui   # 단어 추가 다이얼로그
├── modify_kotoba.cpp/h/ui # 단어 편집 다이얼로그
├── new_dic.cpp/h/ui      # 새 사전 생성 다이얼로그
├── study.cpp/h/ui        # 학습 모드 구현
├── sqlite3.c/h           # SQLite3 데이터베이스 엔진
├── FolygonDic.pro        # Qt 프로젝트 파일
├── *.ts, *.qm            # 번역 파일 (ja, ko, en)
└── imgs/                 # 애플리케이션 리소스
    └── lisence.txt       # 아이콘 라이선스 정보
```

## 라이선스

이 프로그램은 자유 소프트웨어입니다. Free Software Foundation이 공개한 **GNU Lesser General Public License (LGPL)** 버전 3 또는 그 이후 버전의 조건에 따라 재배포 및/또는 수정할 수 있습니다.

이 프로그램은 유용하기를 바라며 배포되지만, **어떠한 보증도 없습니다**. 상품성이나 특정 목적에의 적합성에 대한 묵시적 보증조차 없습니다. 자세한 내용은 GNU Lesser General Public License를 참조하십시오.

이 프로그램과 함께 GNU Lesser General Public License 사본을 받아야 합니다. 받지 못한 경우 <http://www.gnu.org/licenses/>를 참조하십시오.

### Qt 프레임워크 라이선스

이 애플리케이션은 **Qt 프레임워크**를 사용하며, 여러 라이선스로 제공됩니다:
- **LGPL v3** (본 프로젝트에서 사용)
- 상용 라이선스

LGPL v3 하에서 Qt를 사용할 때 다음이 필요합니다:
- 애플리케이션의 소스 코드 제공 (배포하는 경우)
- 사용자가 다른 버전의 Qt로 애플리케이션을 재링크할 수 있도록 허용
- Qt 라이선스 정보 포함

Qt 라이선스에 대한 자세한 내용은 https://www.qt.io/licensing/ 을 참조하십시오.

### 서드파티 라이선스

#### 아이콘
이 애플리케이션에서 사용된 아이콘은 **Feather Icons**에서 제공되며 **MIT 라이선스** 하에 라이선스됩니다:

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

전체 아이콘 라이선스 세부정보는 [imgs/lisence.txt](imgs/lisence.txt)를 참조하십시오.

#### SQLite
이 애플리케이션에는 SQLite3 (sqlite3.c/h)가 포함되어 있으며, **퍼블릭 도메인**입니다.

#### gTTS (Google Text-to-Speech)
Linux에서 이 애플리케이션은 텍스트 음성 변환 기능을 위해 **MIT 라이선스** 하에 라이선스된 **gTTS**를 사용합니다:

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

자세한 정보: https://github.com/pndurette/gTTS

## 작성자

Copyright (C) 2024 Shin Sukju

## 관련 프로젝트

- [FolygonDic Apple](../FolygonDic%20Apple/) - Swift/SwiftUI로 구축된 iOS/macOS/watchOS 버전
- App Store: https://apps.apple.com/jp/app/folygondic/id6754223204

---

**Language / 言語 / 언어**  
[English](README.md) | [日本語](README.ja.md) | 한국어
