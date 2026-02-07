# Voish - The Voice-First Super-App 🎙️

**Voish** is a revolutionary "voice-first" super-app, often referred to as the "WeChat of Pakistan." It simplifies complex digital tasks through natural language voice commands.

---

## 🌟 Core Concept
The heart of Voish is simplicity and speed.
- **Voice-First Navigation:** A giant red microphone button dominates the interface. Users can simply press and speak to perform any task—from ordering food to checking their wallet balance.
- **Intent-Based Interaction:** The app understands user intent and automatically opens the relevant "mini-app" or executes a specific action.
- **Micro-App Ecosystem:** A suite of lightweight, focused services (Food, Ride, Wallet, Chat, etc.) integrated into a single platform.
- **Minimalist Aesthetic:** A premium "Deep Charcoal & Red Accent" theme designed for high contrast and modern feel, optimized for performance on devices with 4GB-6GB RAM.

---

## 🛠️ Detailed Tech Stack

| Layer | Technology |
|-------|------------|
| **Core Framework** | Flutter 3.24+ (Single codebase for Android & iOS) |
| **State Management** | Riverpod 2.x (Lightweight, robust, and scalable) |
| **Authentication** | Firebase Auth (Google Sign-In, Email/Password, Phone Auth) |
| **Database (Cloud)** | Cloud Firestore (Real-time syncing for Chat & User data) |
| **Database (Local)** | Hive (Encrypted offline storage for lightning-fast performance) |
| **Voice Processing** | `speech_to_text` for real-time STT |
| **Design/Animations** | `google_fonts`, `flutter_svg`, `feather_icons`, `animate_do` |
| **Communication** | Firebase Cloud Messaging (FCM) & Local Notifications |

---

## 📂 Project Structure (Clean Architecture)
The project follows a feature-first approach with a clear separation of concerns:

```text
lib/
├── core/                 # Shared logic: themes, constants, extensions
├── models/               # Data structures (User, Message, etc.)
├── services/             # Logic-heavy layers
│   ├── auth_service.dart # Firebase Auth wrapper
│   ├── chat_service.dart # Firestore Chat & User logic
│   └── voice_service.dart# STT & Speech recognition wrapper
├── theme/                # Global styling (Deep Charcoal/Red Accent)
├── widgets/              # Reusable UI components (Mic Button, etc.)
├── l10n/                 # Localization (Urdu, English, etc.)
└── screens/              # UI Screens
    ├── splash_screen.dart # 2-second instant splash
    ├── auth_screen.dart   # Sign-in/Sign-up flow
    ├── voice_hub_screen.dart # Main dashboard with the Red Mic
    └── mini_apps/         # Lazy-loaded feature modules
        ├── chat_app.dart  # E2EE-capable messaging
        ├── wallet_app.dart# PKR Balance & Transactions
        ├── ride_app.dart  # Cab & Bike hailing
        ├── food_app.dart  # Food delivery & groceries
        └── ...            # Doctors, Education, Shopping, etc.
```

---

## 🔄 Screen Flow & Walkthrough
1. **Splash Screen:** Branded launch experience (2 seconds).
2. **Auth Screen:** Secure login via Google or Email/Password. Persistent sessions keep users logged in for 5 days.
3. **Voice Hub (Home):** 
   - Top Bar: Profile access and real-time PKR balance.
   - Middle: Minimalist grid of 9+ service icons.
   - Bottom: "The Pulse" — A massive, animated sphere microphone.
4. **Command Processing:** 
   - User speaks (e.g., "Ali ko 500 bhej" or "Order biryani").
   - The app parses the text and navigates to the specific mini-app.
5. **Mini-Apps:** Focused, full-screen experiences with back-button navigation returning to the Voice Hub.

---

## 🗣️ Voice Parsing Logic (The "Brain")
Voish uses a **Hybrid Keyword-Matching Engine** designed for speed and offline resilience:
- **Phase 1 (Keyword Mapping):** The `VoiceHubScreen` analyzes the recognized text for specific "Triggers."
  - *Food Triggers:* "food", "order", "eat", "khana", "bhook"
  - *Ride Triggers:* "ride", "cab", "go", "taxi", "rastay"
  - *Wallet Triggers:* "wallet", "balance", "paisay", "bhej"
- **Phase 2 (Entity Extraction):** (In Development) Extracting amounts, names, and locations using regex and lightweight on-device processing.
- **Phase 3 (Fallback):** If the command is unclear, the app provides visual feedback ("Adjusting atmosphere...") and prompts for clarification.

---

## 🔐 Security & Privacy
- **Secure Authentication:** Built on Firebase Identity platform with multi-factor support.
- **E2EE Messaging:** All chats are routed through Firestore with plans for client-side encryption using the `encrypt` package.
- **Privacy-First Voice:** Voice data is processed in real-time for command execution; no audio recordings are stored on servers without explicit consent.
- **Local Encryption:** User sensitive data in Hive is encrypted with device-specific keys.

---

## 🚀 Performance & Optimization
- **Tiny Footprint:** Target APK size <20MB using ProGuard and image compression.
- **Lazy Loading:** Mini-apps use deferred loading where possible to minimize initial load time.
- **60 FPS UI:** Animations built with `animate_do` and optimized Painters ensure smooth usage on 4GB RAM devices.
- **Global Accessibility:** Built-in RTL (Right-to-Left) support for Urdu, with language toggles in settings.

---

## 🎨 Design System
- **Background:** Material Black (`#000000`) / Surface Dark (`#121212`)
- **Primary Accent:** Radiant Red (`#FF3B30`)
- **Typography:** Google Fonts (Inter/Outfit for English, Jameel Noori/Standard Sans for Urdu)
- **Glassmorphism:** Subtle blur effects used on overlays and confirmation bubbles.

---

## 🛠️ Setup & Installation
1. Ensure Flutter is installed (`flutter doctor`).
2. Clone the repository.
3. Run `flutter pub get`.
4. Setup Firebase:
   - Create a Firebase project.
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
   - Run `flutterfire configure` to generate `firebase_options.dart`.
5. Run the app: `flutter run`.

---

## 🎁 Bonus: Common Urdu Command Strings
| English Intent | Roman Urdu Trigger | Urdu Script |
|----------------|-------------------|-------------|
| Order Food     | Khana mangwao     | کھانا منگوائیں |
| Check Balance  | Balance check karo | بیلنس چیک کریں |
| Send Money     | Paisay bhejo      | پیسے بھیجیں |
| Call a Ride    | Ride bulao        | سواری بلائیں |

---
*Built with ❤️ for Pakistan.*
