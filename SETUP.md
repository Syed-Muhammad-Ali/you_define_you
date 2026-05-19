# YOU DEFINE YOU — Setup Instructions for Developer
## Ora Life Coaching Ltd

---

## Quick Start (Do these steps in order)

### Step 1 — Make sure Flutter is installed
```bash
flutter --version
```
If not installed: https://docs.flutter.dev/get-started/install
Requires Flutter 3.0+ and Dart 3.0+

### Step 2 — Unzip and open the project
Unzip `YouDefineYou-Flutter-Project.zip` and open the root folder in VS Code or Android Studio.

### Step 3 — Install dependencies
```bash
flutter pub get
```
This downloads all packages listed in pubspec.yaml (google_fonts, provider, shared_preferences etc.)

### Step 4 — Run on a simulator or device
```bash
# List available devices
flutter devices

# Run on a specific device
flutter run -d <device-id>

# Or simply (picks the first available device)
flutter run
```

### Step 5 — Build for release
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires Mac + Xcode)
flutter build ios --release
```

---

## Project Structure

```
lib/
├── main.dart                  ← Entry point + routing + Coach screen
├── theme/theme.dart           ← All colours, fonts, design tokens
├── models/app_state.dart      ← State management (Provider) + persistence
├── data/data.dart             ← All static content (beliefs, tools, questions)
├── widgets/widgets.dart       ← Shared UI components
└── screens/
    ├── onboarding.dart        ← Welcome → Questions → Profile → Commit
    ├── main_screens.dart      ← Home, Foundation (4 steps), Tool viewer
    ├── diary_screen.dart      ← Thought Diary
    └── offboarding.dart       ← Settings, back guards, exit confirmation
```

---

## Common Issues

**`flutter pub get` fails**
→ Make sure you're in the root project folder (where pubspec.yaml is)

**iOS build fails**
→ Run `cd ios && pod install` then try again

**Fonts not loading**
→ Run `flutter pub get` again — google_fonts downloads on first run

**`dart` command not found**
→ Flutter includes Dart — make sure Flutter's bin folder is in your PATH

---

## What Still Needs Building
See README.md for the full list. Key items:
1. Anthropic API key wired into Coach screen
2. Push notifications (flutter_local_notifications)
3. App icons + splash screen
4. App Store + Google Play submission

---

*Ora Life Coaching Ltd — Confidential*
