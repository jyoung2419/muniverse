# 🪐 Muniverse

K-POP 아티스트를 위한 글로벌 팬 투표 & 티켓팅 플랫폼입니다.  
이벤트별 투표, 리워드, VOD, 공연 정보 등을 통합 제공하는 앱입니다.

## 🚀 주요 기능

### ✅ 사용자 기능
- 소셜 로그인 (Google, Twitter)
- 이벤트별 공연 정보 통합 제공
- 이벤트별 투표 참여
- 아티스트 투표 현황 확인
- 티켓 상품 구매 및 이용권 등록
- 마이페이지
  

## 🧱 기술 스택

### Frontend (Flutter)
- `flutter_riverpod`, `provider`: 상태 관리
- `dio`: API 통신 및 인터셉터
- `shared_preferences`: 로컬 저장소
- `go_router`: 라우팅
- `webview_flutter`: 결제 연동
- `intl`, `flutter_svg`, `image_picker`, 등 다양한 유틸 패키지

### Backend (Spring Boot)
> Spring Boot 3 기반의 멀티 데이터 소스 API 서버입니다.   
> MariaDB + MongoDB + Redis를 연동하며, 인증은 Spring Security와 JWT 기반으로 구현되어 있습니다.   
> ⚠️ 현재 리포지토리는 **Frontend (Flutter)** 소스만 포함되어 있습니다.   


## 📦 프로젝트 구조

```bash
lib/
├── screens/           # 주요 화면
├── widgets/           # 공통 위젯
├── models/            # 데이터 모델
├── providers/         # Riverpod 및 Provider 상태관리
├── services/          # API 호출 및 비즈니스 로직
└── utils/             # 유틸리티 함수 및 전역 설정
````


## 📌 .env 설정 예시

```bash
BASE_URL=http://your-api-url.com
PORT=8080
GOOGLE_IOS_CLIENT_ID=GoogleClientIdForIOS #iOS
GOOGLE_ANDROID_CLIENT_ID=GoogleClientIdForAndroid #Android
GOOGLE_WEB_CLIENT_ID=GoogleWebClientId
GOOGLE_API_KEY=GoogleApiKey
```

## 🖥️ 실행 방법

```bash
git clone https://github.com/jyoung2419/muniverse.git
cd muniverse
flutter pub get
flutter run
```

### 💡 참고

* Android/iOS 모두 지원
* `.env` 또는 환경설정은 추후 `.env.sample` 제공 예정

## 📸 주요 화면 스크린샷
<p align="center">
  <img src="https://github.com/user-attachments/assets/7935b72f-39d4-4e8b-b82a-69850598d015" width="45%" />
  <img src="https://github.com/user-attachments/assets/561cb9b5-154c-47c7-93d9-97738f4f5835" width="45%" /><br>
  <img src="https://github.com/user-attachments/assets/9d288d66-c36f-4e4b-8cd3-c4b6537485cb" width="45%" />
  <img src="https://github.com/user-attachments/assets/f439dbf6-34cf-4d81-adb9-c3277f2b2ca7" width="45%" />
</p>


---

⚠️ 해당 프로젝트는 학습/포트폴리오용으로 제작되었으며, 상업적 목적이 아닙니다.


