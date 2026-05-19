# You Define You — Flutter Project
## Ora Life Coaching Ltd

---

## What This Is

A complete Flutter app — iOS, Android, and tablet — converted directly from the original HTML prototype.
Ready to open, run, and deploy.

---

## Project Structure

```
lib/
├── main.dart              ← App entry point & routing
├── theme/
│   └── theme.dart         ← All colours, fonts, button styles
├── models/
│   └── app_state.dart     ← All state + SharedPreferences persistence
├── data/
│   └── data.dart          ← All static content (beliefs, tools, questions, triggers)
├── widgets/
│   └── widgets.dart       ← Shared UI components
└── screens/
    ├── onboarding.dart    ← Welcome → Acknowledge → Questions → Profile → Commit
    ├── main_screens.dart  ← Home, Foundation (all 4 steps), Tool viewer
    └── diary_screen.dart  ← Thought Diary
```

---

## Getting Started

```bash
# 1. Install Flutter (if not already)
# https://docs.flutter.dev/get-started/install

# 2. Install dependencies
flutter pub get

# 3. Run on device/simulator
flutter run

# 4. Build for release
flutter build apk          # Android
flutter build ios          # iOS (requires Mac + Xcode)
```

---

## Screens Built

| Screen | Status |
|--------|--------|
| Welcome (splash) | ✅ Complete |
| Acknowledge | ✅ Complete |
| 5 Questions (dynamic by profile) | ✅ Complete |
| Profile Reveal (ANXIETY/BURNOUT/OVERWHELM) | ✅ Complete |
| Commit + Name entry | ✅ Complete |
| Home Dashboard | ✅ Complete |
| Foundation — Life Assessment | ✅ Complete |
| Foundation — Limiting Beliefs | ✅ Complete |
| Foundation — Timeline Builder | ✅ Complete |
| Foundation — Anxiety Checklist | ✅ Complete |
| Tool Viewer (all 7 tools) | ✅ Complete |
| Thought Diary | ✅ Complete |
| Coach Screen | ✅ Scaffold (needs AI integration) |

---

## What the Developer Needs to Add

1. **Coach AI integration** — connect coach screen to Claude API or OpenAI
2. **Push notifications** — daily diary reminder (use `flutter_local_notifications`)
3. **Tablet layout refinements** — add sidebar nav for screens > 600px wide
4. **App icons & splash screen** — use `flutter_launcher_icons` and `flutter_native_splash`
5. **App Store / Google Play submission** — signing, metadata, screenshots
6. **Analytics** (optional) — Firebase or Amplitude

---

## Design Tokens

All colours live in `lib/theme/theme.dart`:

| Token | Value |
|-------|-------|
| Orange | `#FF6B35` |
| Background | `#0C0C0C` |
| Card | `#1A1A1A` |
| Border | `#252525` |
| Muted text | `#AAAAAA` |

Fonts: **Bebas Neue** (headings) + **DM Sans** (body) via Google Fonts package.

---

## Data Persistence

User data is persisted locally via `shared_preferences`. All data survives app restarts.

For cloud sync (multi-device), add Supabase or Firebase — the AppState class is already
structured to make this straightforward.

---

## Built By

Designed by Ora Life Coaching Ltd using Claude (Anthropic).
Converted to Flutter: [Developer name here]

---

*Confidential — Ora Life Coaching Ltd*
