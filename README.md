# 🌿 Plant& — Heal Naturally, Grow Smarter

<div align="center">

<img src="https://raw.githubusercontent.com/AlsayedAbdelmohiemen/plant_project/main/assets/images/Splash.png" width="200" alt="Plant& Logo" />

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![BLoC](https://img.shields.io/badge/BLoC%2FCubit-State_Mgmt-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://bloclibrary.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

**Your personal guide to natural healing. Discover herbal remedies, explore plant categories,  
get AI-powered plant identification, and find what grows best in your location — all in one app.**

[✨ Features](#-features) • [🏛️ Architecture](#️-architecture) • [🛠️ Tech Stack](#️-tech-stack) • [🚀 Getting Started](#-getting-started) • [📁 Project Structure](#-project-structure)

</div>

---

## 📖 About The Project

**Plant&** is a comprehensive cross-platform Flutter application that bridges herbal medicine and smart technology. Built with production-grade architecture and engineering principles, the app offers:

- A rich **plant encyclopedia** with categories and detailed plant profiles
- **AI-powered plant identification** via an integrated machine learning model
- **Weather-based plant recommendations** using real-time geolocation data
- Full **Dark & Light theme** support with persistent user preferences
- Complete **Arabic (RTL) and English (LTR)** localization
- Robust **Firebase authentication** including Google Sign-In, email verification, and password reset

---

## ✨ Features

### 🔐 Authentication
- **Sign Up / Login** with email & password
- **Google Sign-In** (OAuth 2.0)
- **Email Verification** flow
- **Forgot Password** with OTP page and reset password screen
- Persistent session management

### 🌱 Plant Discovery
- **Home Screen** — Featured plants and curated collections
- **Category Screen** — Browse plants by category (medicinal, indoor, outdoor, etc.)
- **Plant Details Screen** — Full info: description, benefits, care guide, herbal uses
- **My Plants** — Save and manage your personal plant collection

### 🤖 AI Plant Identification
- Integrated **AI Model** for real-time plant recognition from camera/gallery images
- Built-in **Prediction Provider** using Flutter's ML pipeline

### 🌤️ Weather & Recommendations
- **Real-time weather** fetched via location-based API
- **Smart plant recommendations** tailored to current temperature, humidity & climate
- Dedicated **Weather Screen** with icons for different weather conditions

### ⚙️ Settings & Personalization
- **Dark / Light Theme** toggle with persistence (ThemeCubit)
- **Language Switching** — Arabic (RTL) / English (LTR) on the fly (LocalizationCubit)
- **Push Notifications** with custom notification handler & service
- **Profile Management** — Edit profile photo (ImageProfileCubit + ProfileCubit)

### 🎨 UI/UX Polish
- **Splash Screen** with light/dark variants (`Splash.png` / `Splash_dark.png`)
- **Onboarding / Boarding Screen** with animated page view
- Responsive layout using `flutter_screenutil`
- Device preview support via `device_preview`

---

## 🏛️ Architecture

The project follows a clean **BLoC / Cubit + Repository** pattern with clear separation of concerns across three layers:

```
┌─────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                  │
│  Screens: Splash, Onboarding, Auth, Home, Category, │
│  Plant Details, My Plants, Weather, Recommend,       │
│  AI Model, Settings, Layout                          │
└───────────────────────┬─────────────────────────────┘
                        │ emits states / dispatches events
┌───────────────────────▼─────────────────────────────┐
│               BUSINESS LOGIC LAYER                   │
│  Cubits: WeatherCubit, ThemeCubit, LocalizationCubit │
│          ProfileCubit, ImageProfileCubit,            │
│          BoardingCubit, MainCubit                    │
└───────────────────────┬─────────────────────────────┘
                        │ calls repositories
┌───────────────────────▼─────────────────────────────┐
│                    DATA LAYER                        │
│  ├── model/        (Data Models & Entities)          │
│  ├── repository/   (Abstract + Concrete Repos)       │
│  └── web_service/  (Dio API Client & Firebase calls) │
└─────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

| Category | Technology |
|:---|:---|
| **Framework** | Flutter 3.x |
| **Language** | Dart 3.5+ |
| **State Management** | flutter_bloc (BLoC + Cubit) |
| **Backend** | Firebase (Auth, Firestore, Cloud Messaging) |
| **Networking** | Dio |
| **AI / ML** | Custom Plant Model (TFLite / prediction_provider) |
| **Authentication** | Firebase Auth + Google Sign-In |
| **Push Notifications** | Firebase Cloud Messaging (FCM) |
| **Localization** | flutter_localizations + intl (AR/EN) |
| **Theming** | Dynamic Dark/Light with ThemeCubit |
| **Responsive UI** | flutter_screenutil |
| **DI / Service Locator** | Provider |
| **Dev Tools** | device_preview, flutter_sha_fingerprint |
| **Platforms** | Android · iOS · Web · Windows · Linux · macOS |

---

## 📁 Project Structure

```
plant_project/
├── lib/
│   ├── business_logic/
│   │   ├── bording_cubit/        # Onboarding state management
│   │   ├── cubit/                # Main app cubit
│   │   ├── image_cubit/          # Profile image upload cubit
│   │   ├── localization/         # Language switching (AR/EN) cubit
│   │   ├── profile_cubit/        # User profile cubit
│   │   ├── theme_cubit/          # Dark/Light theme cubit
│   │   └── weather_cubit/        # Weather data fetching cubit
│   │
│   ├── data/
│   │   ├── model/                # Data models (Plant, Weather, User...)
│   │   ├── repository/           # Repository pattern implementations
│   │   └── web_service/          # Dio HTTP client & API endpoints
│   │
│   ├── presenatation/
│   │   ├── auth/                 # Login, Register, Verify Email, Forgot Password, OTP, Reset
│   │   ├── bording_screen/       # Onboarding page view & components
│   │   ├── category_screen/      # Plant categories browser
│   │   ├── home/                 # Home screen
│   │   ├── layout/               # Main app layout (bottom nav)
│   │   ├── model/                # AI model screen & prediction_provider
│   │   ├── my_plants/            # User's saved plants
│   │   ├── plants_details/       # Detailed plant view
│   │   ├── recommend/            # Weather-based recommendations
│   │   ├── settings/             # Settings, Notifications
│   │   ├── splash/               # Splash screen
│   │   └── weather/              # Weather screen
│   │
│   ├── constants/                # App colors, strings, routes, assets
│   ├── l10n/                     # Localization .arb files (AR + EN)
│   ├── firebase_options.dart     # Firebase platform config
│   └── main.dart                 # App entry point + BLoC providers setup
│
├── assets/
│   └── images/                   # Splash, onboarding, weather icons, UI assets
├── plant_model/                  # AI plant recognition model files
├── android/                      # Android native config + google-services.json
├── ios/                          # iOS native config + GoogleService-Info.plist
├── web/                          # Flutter web config
├── windows/                      # Windows desktop config
├── pubspec.yaml                  # Dependencies & assets declaration
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

| Tool | Minimum Version | Download |
|---|---|---|
| Flutter SDK | 3.5.0 | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.5.0 | Included with Flutter |
| Android Studio / VS Code | Latest | [developer.android.com](https://developer.android.com/studio) |
| Git | Any | [git-scm.com](https://git-scm.com) |

---

### Installation

**1. Clone the repository:**
```bash
git clone https://github.com/AlsayedAbdelmohiemen/plant_project.git
cd plant_project
```

**2. Install Flutter dependencies:**
```bash
flutter pub get
```

**3. Set up Firebase:**

> ⚠️ This app requires a Firebase project. Follow these steps:

- Go to [Firebase Console](https://console.firebase.google.com/) → **Add project**
- Enable **Authentication** (Email/Password + Google Sign-In)
- Enable **Cloud Firestore**
- Enable **Cloud Messaging (FCM)**
- Add your apps (Android / iOS / Web) and download config files:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

Or manually place:
- `google-services.json` → `android/app/google-services.json`
- `GoogleService-Info.plist` → `ios/Runner/GoogleService-Info.plist`

**4. Configure the Weather API:**

The app fetches real-time weather data. Add your API key in `lib/constants/`:
```dart
// lib/constants/api_constants.dart (or similar)
const String weatherApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
```
Get a free key from [openweathermap.org](https://openweathermap.org/api)

**5. Generate localization files:**
```bash
flutter gen-l10n
```

**6. Run the app:**
```bash
# Android (connected device or emulator)
flutter run

# iOS (requires macOS + Xcode)
flutter run -d ios

# Web (Chrome)
flutter run -d chrome

# Windows Desktop
flutter run -d windows
```

---

## 🌍 Localization

The app supports **full bilingual experience**:

| Language | Direction | Code |
|---|---|---|
| English | LTR ← | `en` |
| Arabic | RTL → | `ar` |

Translation files are in `lib/l10n/`. To add a new language:
1. Create a new `.arb` file (e.g., `app_fr.arb`)
2. Run `flutter gen-l10n`
3. Add the locale to `supportedLocales` in `main.dart`

---

## 🤝 Contributing

Contributions are always welcome! 🙌

```bash
# 1. Fork the project
# 2. Create your feature branch
git checkout -b feature/AmazingFeature

# 3. Commit your changes
git commit -m 'feat: add AmazingFeature'

# 4. Push to the branch
git push origin feature/AmazingFeature

# 5. Open a Pull Request
```

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.

---

## 👨‍💻 Author

**Elsayed Abd Al-Mohaymen**  
Junior Flutter Developer | Clean Architecture Advocate

[![GitHub](https://img.shields.io/badge/GitHub-AlsayedAbdelmohiemen-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/AlsayedAbdelmohiemen)
[![Gmail](https://img.shields.io/badge/Email-sayedabdelmohiemen1%40gmail.com-D14836?style=flat-square&logo=gmail&logoColor=white)](mailto:sayedabdelmohiemen1@gmail.com)

---

<div align="center">

Made with ❤️ using Flutter

*"Stay healthy, grow smarter, and connect with nature — wherever you are."* 🌿

![Profile Views](https://komarev.com/ghpvc/?username=AlsayedAbdelmohiemen&color=2ea44f&style=flat-square&label=Profile+Views)

</div>
