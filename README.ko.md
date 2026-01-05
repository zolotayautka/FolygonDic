# <img src="https://github.com/zolotayautka/FolygonDic/blob/main/FolygonDic Apple/FolygonDic/Assets.xcassets/AppIcon.appiconset/icon.png" width="30"> FolygonDic

**자신만의 단어장을 만들어 학습하는 어휘 학습 앱 - Apple 플랫폼 및 데스크톱 지원**

FolygonDic은 두 가지 버전으로 제공되는 종합 어휘 학습 애플리케이션입니다:
- **Apple 버전**: iOS, iPadOS, macOS, watchOS
- **PC 버전**: Windows, macOS, Linux 데스크톱

## 📱 Apple 버전

App Store에서 iPhone, iPad, Mac, Apple Watch용으로 다운로드 가능.

**[App Store에서 다운로드](https://apps.apple.com/jp/app/folygondic/id6754223204)**

### 주요 기능
- **멀티 플랫폼**: iOS, iPadOS, macOS, watchOS
- **Apple Watch 연동**: iPhone과 Watch 간 학습 단어 전송 및 동기화
- **일일 알림**: 매일 정오에 학습 알림
- **네이티브 경험**: Swift와 SwiftUI로 구축
- **7가지 품사**: 조사, 전치사, 명사, 동사, 형용사, 부사, 기타

### 기술 스택
- Swift, SwiftUI
- SQLite3 데이터베이스
- AVFoundation (TTS), UserNotifications, WatchConnectivity
- 최소 요구사항: iOS 14.0+

**[Apple 버전 자세히 보기 →](FolygonDic%20Apple/README.ko.md)**

---

## 🖥️ PC 버전

Qt 프레임워크로 구축된 크로스 플랫폼 데스크톱 애플리케이션.

### 주요 기능
- **크로스 플랫폼**: Windows, macOS, Linux
- **Qt 프레임워크**: 모든 플랫폼에서 네이티브 데스크톱 경험
- **오프라인 우선**: 로컴에 저장되는 SQLite 데이터베이스
- **다국어 TTS**: 
  - macOS/Windows: 플랫폼 네이티브 텍스트 음성 변환
  - Linux: gTTS (Google Text-to-Speech) 라이브러리
- **6가지 품사**: 조사/전치사, 명사, 동사, 형용사, 부사, 기타

### 기술 스택
- C++ (C++11)
- Qt 5/6 (Qt Core, Gui, Widgets, Charts)
- SQLite3 (임베디드)
- qmake 빌드 시스템

**[PC 버전 자세히 보기 →](FolygonDic%20Pc/README.ko.md)**

---

## 🌟 공통 기능

두 버전에서 공통으로 제공되는 핵심 기능:

### 📝 단어 관리
- 단어 항목 추가, 편집, 삭제
- 품사별 분류
- 다중 필드 지원: 단어, 한자, 의미, 비고
- 모든 필드에서 실시간 검색

### 🎯 학습 기능
- **음성 재생(TTS)**: 선택한 언어로 발음 듣기
- **학습 횟수 추적**: 학습 진행 상황 자동 기록
- **학습 모드**: 플래시카드 스타일 학습 인터페이스
- **학습 통계**: 차트로 진행 상황 시각화

### 🌍 다국어 지원
- 한국어 (ko)
- 일본어 (ja)
- 영어 (en)
- 언어별 TTS 음성

### 💾 데이터 관리
- SQLite 기반 로컬 데이터베이스
- 완전한 오프라인 기능
- 안정적인 데이터 저장

---

## 📂 리포지토리 구조

```
FolygonDic/
├── FolygonDic Apple/     # iOS, macOS, watchOS 버전 (Swift/SwiftUI)
│   ├── FolygonDic/       # 메인 iOS/macOS 앱
│   ├── FolygonDic Watch App/  # watchOS 컴패니언 앱
│   └── README.md         # Apple 버전 문서
│
└── FolygonDic Pc/        # 데스크톱 버전 (C++/Qt)
    ├── *.cpp/h           # 소스 파일
    ├── *.ui              # Qt Designer UI 파일
    ├── FolygonDic.pro    # Qt 프로젝트 파일
    └── README.md         # PC 버전 문서
```

---

## 📄 라이선스

### Apple 버전
Copyright (C) 2024 Shin Sukju  
자세한 내용은 [FolygonDic Apple](FolygonDic%20Apple/)을 참조하세요.

### PC 버전
이 프로그램은 **GNU Lesser General Public License (LGPL) v3**로 라이선스됩니다.

#### Qt 프레임워크
이 애플리케이션은 **LGPL v3** 라이선스 하에 Qt 프레임워크를 사용합니다.  
자세한 정보: https://www.qt.io/licensing/

#### 서드파티 구성 요소
- **아이콘**: Feather Icons (MIT 라이선스) (https://feathericons.com/)
- **SQLite**: 퍼블릭 도메인
- **gTTS** (Linux전용): Google Text-to-Speech 라이브러리 (MIT 라이선스) (https://github.com/pndurette/gTTS)

아이콘 라이선스 세부정보는 [FolygonDic Pc/imgs/lisence.txt](FolygonDic%20Pc/imgs/lisence.txt)를 참조하세요.

##### Feather Icons 라이선스
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

자세한 정보: https://feathericons.com/

##### gTTS 라이선스 (Linux 전용)
PC 버전은 Linux에서 텍스트 음성 변환 기능을 위해 **MIT 라이선스** 하에 라이선스된 **gTTS**를 사용합니다:

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

전체 라이선스 정보는 [FolygonDic Pc/README.ko.md](FolygonDic%20Pc/README.ko.md)에서 확인할 수 있습니다.

---

## 🌐 문서

**Language / 言語 / 언어**

### 메인 README
- [English](README.md)
- [日本語](README.ja.md)
- 한국어 (현재)

### 플랫폼별 문서
- **Apple 버전**: [EN](FolygonDic%20Apple/README.md) | [JA](FolygonDic%20Apple/README.ja.md) | [KO](FolygonDic%20Apple/README.ko.md)
- **PC 버전**: [EN](FolygonDic%20Pc/README.md) | [JA](FolygonDic%20Pc/README.ja.md) | [KO](FolygonDic%20Pc/README.ko.md)

---

## 👨‍💻 작성자

**Shin Sukju**  
Copyright (C) 2024

---

## 🔗 링크

- **App Store**: https://apps.apple.com/jp/app/folygondic/id6754223204
- **Apple 버전 문서**: [FolygonDic Apple/README.ko.md](FolygonDic%20Apple/README.ko.md)
- **PC 버전 문서**: [FolygonDic Pc/README.ko.md](FolygonDic%20Pc/README.ko.md)
