# Przypominapka

![App CI](https://github.com/micang7/przypominapka/actions/workflows/app-ci.yaml/badge.svg)
![Server CI](https://github.com/micang7/przypominapka/actions/workflows/server-ci.yaml/badge.svg)

---

A full-stack mobile application designed to remind users of tasks based on specific conditions—whether triggered at a scheduled time or upon entering a designated geographic area (geofencing). Built with Flutter for cross-platform mobile delivery and Node.js/TypeScript backend, Przypominapka employs an offline-first architecture with reactive synchronization via Firebase Cloud Messaging to ensure seamless task management across devices.

## Screenshots

<table>
  <tr>
    <td align="center"><img src="assets/Login_Screen.png" height="330" /></td>
    <td align="center"><img src="assets/App_Home_Screen.png" height="330" /></td>
    <td align="center"><img src="assets/Add_New_Time-Based_Task.png" height="330" /></td>
    <td align="center"><img src="assets/Edit_Time-Based_Task.png" height="330" /></td>
    <td align="center"><img src="assets/Add_New_Location-Based_Task.png" height="330" /></td>
  </tr>
  <tr>
    <td align="center"><strong>Login Screen</strong></td>
    <td align="center"><strong>App Home Screen</strong></td>
    <td align="center"><strong>Add New Time-Based Task</strong></td>
    <td align="center"><strong>Edit Time-Based Task</strong></td>
    <td align="center"><strong>Add New Location-Based Task</strong></td>
  </tr>
  <tr>
    <td align="center"><img src="assets/Add_New_Location-Based_Task2.png" height="330" /></td>
    <td align="center"><img src="assets/Deleting_a_Task.png" height="330" /></td>
    <td align="center"><img src="assets/Notification.png" height="330" /></td>
    <td align="center"><img src="assets/Side_menu.png" height="330" /></td>
    <td align="center"></td> </tr>
  <tr>
    <td align="center"><strong>Add New Location-Based Task</strong></td>
    <td align="center"><strong>Deleting a Task</strong></td>
    <td align="center"><strong>Notification</strong></td>
    <td align="center"><strong>Side menu</strong></td>
    <td></td>
  </tr>
</table>

## Features

- **Location-Based Reminders (Geofencing)** – Trigger tasks automatically when entering or exiting defined geographic areas using native geofencing APIs.
- **Time-Based Reminders** – Schedule reminders for specific times with persistent background handling.
- **Offline-First Architecture** – Full task management capability offline with local reactive database synchronization.
- **Background Sync via Silent Push Notifications** – Real-time synchronization across devices using Firebase Cloud Messaging (FCM) silent data messages.
- **Secure Authentication** – JWT-based token management with encrypted storage.
- **Map-Based Task Visualization** – Interactive Google Maps integration for geolocation-aware task planning and management.
- **Cross-Platform Support** – Native Android and iOS applications built with Flutter.

## <img src="https://api.iconify.design/lucide:cpu.svg?color=%236366f1" width="22" height="22" style="vertical-align: middle; margin-bottom: 3px;"> Tech Stack

### <img src="https://api.iconify.design/lucide:smartphone.svg?color=%2306b6d4" width="18" height="18" style="vertical-align: middle; margin-bottom: 3px;"> Frontend (Mobile App)

#### Core & Architecture

- <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Main cross-platform framework.
- <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=flat&logo=dart&logoColor=white" style="vertical-align: middle;"> – Core programming language.
- <img src="https://img.shields.io/badge/Riverpod-%2302569B.svg?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Reactive state management & DI.
- <img src="https://img.shields.io/badge/Freezed-%2302569B.svg?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Data models & JSON serialization.
- <img src="https://img.shields.io/badge/GoRouter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Declarative routing & deep linking.

#### Data & Networking

- <img src="https://img.shields.io/badge/Dio-00A98F?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Advanced HTTP client with interceptors.
- <img src="https://img.shields.io/badge/Drift-1A73E8?style=flat&logo=dart&logoColor=white" style="vertical-align: middle;"> – Reactive local SQL database.
- <img src="https://img.shields.io/badge/Secure_Storage-4CAF50?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Encrypted token & sensitive data storage.

#### Native, Location & Notifications

- <img src="https://img.shields.io/badge/Google_Maps-4285F4?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Interactive maps & task visualization.
- <img src="https://img.shields.io/badge/Geolocator-FF5722?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Foreground active location tracking.
- <img src="https://img.shields.io/badge/Native_Geofence-673AB7?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – OS-level background geofencing.
- <img src="https://img.shields.io/badge/Local_Notifications-FF9800?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Trigger-based native push alerts.

### <img src="https://api.iconify.design/lucide:server.svg?color=%233b82f6" width="18" height="18" style="vertical-align: middle; margin-bottom: 3px;"> Backend (API)

- <img src="https://img.shields.io/badge/TypeScript-%23007ACC.svg?style=flat&logo=typescript&logoColor=white" style="vertical-align: middle;"> – Core programming language.
- <img src="https://img.shields.io/badge/express.js-%23404d59.svg?style=flat&logo=express&logoColor=white" style="vertical-align: middle;"> – Web framework.
- <img src="https://img.shields.io/badge/zod-%233E67B1.svg?style=flat&logo=zod&logoColor=white" style="vertical-align: middle;"> – Schema validation & type inference.
- <img src="https://img.shields.io/badge/JWT-black?style=flat&logo=JSON%20web%20tokens&logoColor=white" style="vertical-align: middle;"> – Secure authentication.
- <img src="https://img.shields.io/badge/OpenAPI-%236BA539.svg?style=flat&logo=openapi-initiative&logoColor=white" style="vertical-align: middle;"> / <img src="https://img.shields.io/badge/-Swagger_UI-%2385EA2D?style=flat&logo=swagger&logoColor=black" style="vertical-align: middle;"> – API documentation.
- <img src="https://img.shields.io/badge/pino-555555?style=flat&logo=pino&logoColor=white" style="vertical-align: middle;"> – Low-overhead logging.

### <img src="https://api.iconify.design/lucide:database.svg?color=%2310b981" width="18" height="18" style="vertical-align: middle; margin-bottom: 3px;"> Database

- <img src="https://img.shields.io/badge/PostgreSQL-%23316192.svg?style=flat&logo=postgresql&logoColor=white" style="vertical-align: middle;"> – Relational database.
- <img src="https://img.shields.io/badge/neon.tech-00E599?style=flat&logo=neon&logoColor=black" style="vertical-align: middle;"> – Serverless Postgres cloud platform.
- <img src="https://img.shields.io/badge/Drizzle%20ORM-C5F74F?style=flat&logo=drizzle&logoColor=black" style="vertical-align: middle;"> – TypeScript ORM for SQL databases.

### <img src="https://api.iconify.design/lucide:cloud.svg?color=%233b82f6" width="18" height="18" style="vertical-align: middle; margin-bottom: 3px;"> Cloud Services

- <img src="https://img.shields.io/badge/Firebase_FCM-%23f2550d?style=flat&logo=firebase&logoColor=white" style="vertical-align: middle;"> – Silent push notifications reactive sync.

### <img src="https://api.iconify.design/lucide:shield-check.svg?color=%23f43f5e" width="18" height="18" style="vertical-align: middle; margin-bottom: 3px;"> Code Quality & Testing

- <img src="https://img.shields.io/badge/Test-%2302569B.svg?style=flat&logo=Flutter&logoColor=white" style="vertical-align: middle;"> – Native unit & widget testing framework.
- <img src="https://img.shields.io/badge/Mocktail-%230175C2.svg?style=flat&logo=dart&logoColor=white" style="vertical-align: middle;"> – Code-generation-free mocking library.
- <img src="https://img.shields.io/badge/-Vitest-%237B9D2C?style=flat&logo=vitest&logoColor=white" style="vertical-align: middle;"> – Unit testing framework.
- <img src="https://img.shields.io/badge/Supertest-8A2BE2?style=flat" style="vertical-align: middle;"> – Integration & API endpoint testing.
- <img src="https://img.shields.io/badge/eslint-%234B32C3.svg?style=flat&logo=eslint&logoColor=white" style="vertical-align: middle;"> – Code linting and quality control.
- <img src="https://img.shields.io/badge/prettier-%23F7B93E.svg?style=flat&logo=prettier&logoColor=black" style="vertical-align: middle;"> – Code formatting.

### <img src="https://api.iconify.design/lucide:terminal.svg?color=%23eab308" width="18" height="18" style="vertical-align: middle; margin-bottom: 3px;"> DevOps & Infrastructure

- <img src="https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white" style="vertical-align: middle;"> – Local multi-container environments.
- <img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=githubactions&logoColor=white" style="vertical-align: middle;"> – CI/CD automation pipelines.
- <img src="https://img.shields.io/badge/Render-000000?style=flat&logo=render&logoColor=white" style="vertical-align: middle;"> – Production cloud hosting.

## Project Architecture

Przypominapka is built on a multi-layered, decoupled architecture designed to support a robust **Offline-First** paradigm. It consists of a cross-platform Flutter mobile application and a stateless Node.js/TypeScript REST API.

```
+------------------------------------------------------------+
|                          PRESENTATION                      |
|            Flutter UI Widgets (Screens & Components)       |
+------------------------------------------------------------+
                             │  ▲
              State Updates  │  │  Reads Immutable State
                             ▼  │
+------------------------------------------------------------+
|                     VIEWMODEL (RIVERPOD)                   |
|          State Notifiers & Auto-Generated Providers        |
+------------------------------------------------------------+
                             │  ▲
             Invokes Methods │  │  Emits Domain Entities
                             ▼  │
+------------------------------------------------------------+
|                        DOMAIN LAYER                        |
|          Business Logic, Entities & Repository Contracts   |
+------------------------------------------------------------+
                             │  ▲
              Data Requests  │  │  Returns Clean Data Models
                             ▼  │
+------------------------------------------------------------+
|                         DATA LAYER                         |
|    Repository Implementations, DTOs & Sync Coordination    |
+------------------------------------------------------------+
               │                               ▲
      Local    │                               │    Remote
   Operations  ▼                               │  API Requests
+--------------------------+       +-------------------------+
|    LOCAL DATASOURCE      |       |    REMOTE DATASOURCE    |
|  Drift (Reactive SQLite) |       |     Dio (HTTP Client)   |
+--------------------------+       +-------------------------+
```

### Mobile App (Flutter)

The mobile app follows a feature-driven **Clean Architecture** combined with **MVVM**, utilizing **Riverpod** for state management and dependency injection:

- **Presentation Layer (View & ViewModel):** Declarative UI widgets interact with Riverpod providers, which expose immutable states generated via **freezed**.
- **Domain Layer:** Contains pure business logic, core entities, and abstract repository interfaces, remaining entirely framework-independent.
- **Data Layer:** Implements repository contracts and manages data mapping via DTOs across two data sources:
  - _Local Data Source:_ Handles local persistence using **Drift** (reactive SQLite) to provide immediate UI updates via streams.
  - _Remote Data Source:_ Manages API calls using **Dio**, featuring automatic JWT token refresh interceptors.

### Offline-First & Reactive Sync

The application prioritizes local storage to ensure uninterrupted functionality without network connectivity:

- All write, update and delete operations are immediately committed to the local Drift database and flagged with sync metadata (e.g., `isPendingSync`).
- Multi-device synchronization is achieved via Firebase Cloud Messaging (**Silent Push Notifications**).
- A **Background Isolate Handler** intercepts these messages even when the app is closed, fetches delta updates from the backend `/sync` endpoint, and applies them to the local database, instantly triggering reactive UI updates.

### Backend Server (Node.js & TypeScript)

The backend is a stateless, secure REST API built with **Express.js** and TypeScript, focused on strict schema safety:

- **Type-Safe Contract:** Endpoints and routing are explicitly typed using **@ts-rest/express** for compile-time type safety between contracts and controllers.
- **Request Validation:** Every incoming request undergoes strict runtime validation via **Zod** middleware, instantly rejecting malformed data.
- **Business & Database Layer:** Controllers delegate operations to services, while data persistence is handled in a serverless **PostgreSQL (neon.tech)** database via **Drizzle ORM**.
- **Authentication:** Sessions are stateless and secured by automated **JWT** access and refresh token authentication middleware.

## <img src="https://api.iconify.design/lucide:rocket.svg?color=%2322c55e" width="22" height="22" style="vertical-align: text-bottom; margin-bottom: 3px;"> Frontend Setup (Flutter Mobile App)

To run the Flutter mobile application on Android or iOS devices/emulators:

### 1. Configure Google Maps API Key

Before building the Flutter app, you must add your Google Maps API key to the Android configuration:

```
echo "maps_api_key=YOUR_GOOGLE_MAPS_API_KEY" >> app/android/local.properties
```

Replace YOUR_GOOGLE_MAPS_API_KEY with your actual Google Maps API key.

### 2. Navigate to App Directory

```
cd app
```

### 3. Install Dependencies

```
flutter pub get
```

### 4. Generate Code (Freezed, Riverpod, etc.)

```
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the App

```
flutter run
```

This command will launch the app on a connected device or running emulator.

## <img src="https://api.iconify.design/lucide:layers.svg?color=%236366f1" width="22" height="22" style="vertical-align: text-bottom; margin-bottom: 3px;"> Backend Setup (Express API Server)

### Prerequisites

Before setting up the project environment, ensure you have the following components installed:

- <img src="https://api.iconify.design/lucide:container.svg?color=%2338bdf8" width="18" height="18" style="vertical-align: text-bottom;"> **Docker & Docker Compose** _(Recommended for containerized development)_
- <img src="https://api.iconify.design/lucide:code-2.svg?color=%234ade80" width="18" height="18" style="vertical-align: text-bottom;"> **Node.js v24.x LTS** _(Required for local development)_
- <img src="https://api.iconify.design/lucide:database.svg?color=%233b82f6" width="18" height="18" style="vertical-align: text-bottom;"> **PostgreSQL v16+** _(Required for standalone database setups)_

### Quick Start (Docker Compose)

The fastest and most reliable way to spin up the entire backend ecosystem is by using Docker Compose.

### 1. Clone the Repository

```bash
git clone https://github.com/micang7/przypominapka.git
cd przypominapka
```

### 2. Configure Environment Variables

```bash
cp server/.env.example server/.env
```

### 3. Launch Services

```bash
docker compose up -d
```

### 4. Run database migrations

```bash
docker compose exec server npm run migrate
```

### Service Availability

Once the containers are successfully running, the following services will be accessible:

|                                       |                                                                                                                                  |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **API Base URL**                      | `http://localhost:3000/api/v1`                                                                                                   |
| **Interactive API Docs (Swagger UI)** | [http://localhost:3000/api/v1/docs/ui](https://www.google.com/search?q=http://localhost:3000/api/v1/docs/ui)                     |
| **OpenAPI Schema (JSON)**             | [http://localhost:3000/api/v1/docs/openapi.json](https://www.google.com/search?q=http://localhost:3000/api/v1/docs/openapi.json) |
| **Database Instance**                 | `localhost:5433`                                                                                                                 |

## Project Structure

```
przypominapka/
├── .github/workflows/      # Konfiguracja automatyzacji CI/CD (GitHub Actions)
│
├── app/                    # 📱 FRONTEND (Aplikacja Flutter)
│   ├── android/, ios/      # Pliki natywne i konfiguracje dla Androida oraz iOS
│   ├── linux/, macos/      # Pliki natywne dla systemów desktopowych
│   ├── web/, windows/      # Pliki dla przeglądarek i systemu Windows
│   │
│   └── lib/                # Główny kod źródłowy aplikacji (Dart)
│       ├── core/           # Współdzielone usługi i infrastruktura
│       │   ├── api/        # Modele bazowe API
│       │   ├── database/   # Konfiguracja bazy Drift i definicje tabel
│       │   ├── http/       # Zaawansowany klient sieciowy (Dio)
│       │   ├── router/     # Deklaratywna nawigacja (GoRouter)
│       │   └── services/   # Usługi natywne (FCM, Geofencing)
│       │
│       └── features/       # Moduły funkcjonalne (Clean Architecture)
│           ├── auth/       # Logowanie i zarządzanie sesją
│           │   ├── data/           # Repozytoria i źródła danych
│           │   └── presentation/   # Dostawcy stanu (Riverpod) i ekrany UI
│           └── tasks/      # Główny moduł zarządzania zadaniami
│               ├── data/           # DTO, lokalne/zdalne źródła danych
│               ├── domain/         # Abstrakcje, interfejsy repozytoriów (Encje)
│               └── presentation/   # Widżety, ekrany i logika prezentacji
│
└── server/                 # ⚙️ BACKEND (Serwer API Node.js)
    └── src/                # Główny kod źródłowy serwera
        ├── api/            # Definicje schematów DTO (Auth, Sync, Users)
        ├── config/         # Konfiguracja środowiska i stałe
        ├── db/             # Połączenie z bazą, migracje i skrypty bazy danych
        ├── middleware/     # Oprogramowanie pośredniczące (np. walidacja JWT)
        ├── modules/        # Logika biznesowa serwera (End-pointy i serwisy)
        │   ├── auth/       # Uwierzytelnianie
        │   ├── sessions/   # Zarządzanie urządzeniami (deviceId, tokeny FCM)
        │   ├── sync/       # Synchronizacja danych zadań (Offline-First)
        │   └── users/      # Operacje na danych użytkowników
        └── utils/          # Funkcje pomocnicze backendu
```
