# Feedback App — Flutter

A User Feedback Collection Application built with Flutter for the RemoteWard internship assignment.

## Overview

The app allows a device owner to authenticate via Google Sign-In, collect structured user feedback (including descriptions and media), and securely export the data as a CSV file.

## Tech Stack

- **Flutter** — Cross-platform mobile framework
- **Firebase Auth** — Google Sign-In + Email/Password authentication
- **BLoC** (`flutter_bloc`) — State management architecture
- **SQLite** (`sqflite`) — Local database for feedback and user data
- **get_it** — Dependency injection / service locator
- **image_picker** — Media collection (camera + gallery)
- **local_auth** — Biometric/password authentication before CSV export

## App Flow

```
Login Screen
    ↓
Check if profile exists in DB
    ↓                    ↓
Profile exists       New user
    ↓                    ↓
Home Screen         Profile Screen
                         ↓
                    Save profile
                         ↓
                    Home Screen
                         ↓ (tap +)
                  User Details Screen
                         ↓
                  Bug Description Screen
                         ↓
                  Media Collection Screen
                         ↓
                  Thank You Screen (auto-redirects after 3s)
                         ↓
                  User Details Screen (new entry)
```

## Screens

1. **Login Screen** — Google Sign-In + Email/Password with email verification
2. **User Details Screen** — Collects name, email, contact of person submitting feedback
3. **Bug Description Screen** — Device info + detailed bug description
4. **Media Collection Screen** — Attach screenshots/images from gallery or camera
5. **Thank You Screen** — Success message, auto-redirects to User Details after 3 seconds

## Features

- Google Sign-In via Firebase Authentication
- Email/password registration with email verification
- BLoC pattern for all UI state management
- SQLite database with dedicated service layer
- Dependency injection via get_it
- CSV export with biometric/password authentication
- Feedback list on Home screen with pull-to-refresh
- Profile screen with edit support
- New user detection — redirects to profile setup on first login

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── enums/
│   └── menu_action.dart
├── models/
│   ├── feedback_entry.dart
│   ├── feedback_event.dart
│   ├── feedback_state.dart
│   ├── feedback_bloc.dart
│   └── service_locator.dart
├── services/
│   ├── auth/
│   │   ├── auth_provider.dart
│   │   ├── auth_service.dart
│   │   ├── auth_user.dart
│   │   ├── auth_exceptions.dart
│   │   └── firebase_auth_provider.dart
│   ├── db/
│   │   └── database_service.dart
│   └── csv_export_service.dart
└── views/
    ├── Register_Login_View.dart
    ├── app_shell.dart
    ├── notes_view.dart
    ├── profile_view.dart
    ├── user_details_screen.dart
    ├── bug_screen.dart
    ├── media_screen.dart
    └── thankyou_screen.dart
```

## Setup

1. Clone the repository
2. Run `flutter pub get`
3. Firebase is already configured — no additional setup needed
4. Add SHA-1 fingerprint to Firebase Console if testing on a new device:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```
5. Run the app:
```bash
flutter run
```

## CSV Export Format

| Device Owner | User Details | Bug/Issue | User Device | Description and Media Links |
|---|---|---|---|---|

Export is protected by biometric/password authentication and saved to the device storage.

## Design Choices

- **BLoC over Provider/setState** — Chosen for clean separation of business logic and UI, making the codebase scalable and testable
- **SQLite over Firebase Firestore** — Local-first approach ensures the app works offline and keeps user data on-device
- **get_it for DI** — Lightweight service locator that avoids passing dependencies through widget trees
- **Separate screens for each feedback step** — Improves UX by breaking a long form into focused steps

## Challenges

- Integrating BLoC with SQLite required careful event/state design to handle loading, success, and error states cleanly
- Biometric auth fallback (password) needed careful handling for devices without biometric hardware
- Scoped storage on Android required proper permission setup in AndroidManifest

## Potential Improvements

- Add video support in media collection screen
- Add ability to view full feedback details from the home screen
- Cloud sync option to backup feedback to Firebase Firestore
- Search and filter feedback on home screen
- Dark mode support
