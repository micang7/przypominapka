# Autentykacja Flutter - Instrukcja Implementacji

## 🎯 Struktura wdrożona

```
lib/
├── core/
│   ├── http/
│   │   ├── dio_client.dart         # HTTP client wrapper
│   │   ├── http_config.dart        # Konfiguracja (base URL)
│   │   ├── http_client_provider.dart # Riverpod provider
│   │   └── index.dart              # Barrel file
│   └── router/
│       └── app_router.dart         # (zaktualizowany)
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── auth_remote_datasource.dart  # API calls
│       │   │   └── auth_local_datasource.dart   # Secure storage
│       │   ├── models/
│       │   │   ├── user_dto.dart
│       │   │   ├── auth_response_dto.dart
│       │   │   ├── login_request_dto.dart
│       │   │   └── register_request_dto.dart
│       │   └── repositories/
│       │       └── auth_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── user.dart
│       │   │   └── auth_response.dart
│       │   └── repositories/
│       │       └── auth_repository_contract.dart
│       └── presentation/
│           ├── providers/
│           │   ├── auth_providers.dart          # Dependency injection
│           │   ├── auth_state_provider.dart     # State management
│           │   └── index.dart
│           └── screens/
│               ├── login_screen.dart            # (zaktualizowany)
│               └── register_screen.dart         # (zaktualizowany)
```

## 📋 Kroki do uruchomienia

### 1️⃣ Zainstaluj zależności
```bash
cd app
flutter pub get
```

### 2️⃣ Wygeneruj kod (DTOs i inne)
```bash
flutter pub run build_runner build
```

Jeśli chcesz watch mode (automatyczne generowanie przy zmianach):
```bash
flutter pub run build_runner watch
```

### 3️⃣ Sprawdzenie brak błędów
```bash
flutter analyze
```

### 4️⃣ Uruchom aplikację
```bash
flutter run
```

---

## 🔧 Konfiguracja

### HTTP Client - zmiana URL w produkcji
W pliku `lib/core/http/http_config.dart`:
```dart
static const String baseUrl = 'https://api.example.com'; // Production
```

### Secure Storage - iOS (jeśli potrzebne)
W `ios/Runner/Info.plist` dodaj (standardowo nie potrzebne):
```xml
<key>NSFaceIDUsageDescription</key>
<string>Biometric authentication</string>
```

---

## 🔐 Architektura i przepływ

### Login Flow
1. Użytkownik wpisuje login/hasło
2. Screen -> Provider notifier -> Repository
3. Repository -> Remote Datasource -> HTTP POST /auth/login
4. Response -> Local Datasource (secure storage dla tokenów)
5. State Update -> UI przechodzi do /home

### Token Management
- **Access Token**: Przechowywany w Secure Storage, wysyłany w Authorization header
- **Refresh Token**: Przechowywany w Secure Storage
- **Auto-refresh**: (TODO) Implementuj logikę odświeżania przed expiration

---

## 🧪 Testowanie

### Test logowania (backend musi działać)
1. Upewnij się że backend działa na localhost:3000
2. Wpisz login i hasło
3. Kliknij "Zaloguj się"

### Test rejestracji
1. Kliknij "Zarejestruj się" na login screen
2. Wypełnij formularz
3. Kliknij "Zarejestruj się"

### Błędy i debugging
- Sprawdź Logcat (Android) lub Console (iOS)
- DioClient ma logging - zobacz output w terminalu

---

## 📝 Notatki implementacyjne

✅ **Zrobione:**
- ✔ HTTP Client z Dio
- ✔ Secure Token Storage
- ✔ Freezed DTOs (code generation)
- ✔ Domain/Data separation (Clean Architecture)
- ✔ Riverpod State Management
- ✔ Login screen z logką
- ✔ Register screen z validacją
- ✔ Error handling
- ✔ Loading states

⏳ **TODO (przyszłe):**
- [ ] Token refresh logic (auto-refresh przy expiration)
- [ ] Password reset flow
- [ ] User profile management
- [ ] Logout cleanup
- [ ] Unit tests
- [ ] Widget tests
- [ ] Custom error handling widgets

---

## ⚙️ Troubleshooting

### "BuildContext mixin not found"
```bash
flutter pub get && flutter pub run build_runner build
```

### DTOs nie generują się
```bash
flutter pub run build_runner build --verbose
```

### "FlutterSecureStorage not initialized"
- Ensure pubspec.yaml dependencies są zainstalowane
- Restart aplikacji

### Backend connection refused
- Sprawdź czy backend działa na port 3000
- Zmień URL w `http_config.dart` jeśli to dev na innym porcie

---

## 🎓 Key Concepts

- **Riverpod**: Reactive dependency injection & state management
- **Freezed**: Code generator dla immutable classes & DTOs
- **go_router**: Type-safe routing
- **flutter_secure_storage**: Bezpieczne przechowywanie tokena
- **Dio**: HTTP client z interceptors
- **Clean Architecture**: Separation of concerns (Presentation/Domain/Data)

---

## 📞 Support Notes

Backend API używa pola `login` a nie `email`. Screenów zmieniono z email na login field.
Backend zwraca user profile, access/refresh tokens oraz expiresAt timestamps.
