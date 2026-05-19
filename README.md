# Transaction History — Flutter Clean Architecture Demo

A production-quality Flutter app demonstrating **Clean Architecture**, **Test-Driven Development (TDD)**, and **flutter_bloc** state management. Built as an interview technical exercise.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Running the App](#running-the-app)
- [Running Tests](#running-tests)
- [Design Decisions](#design-decisions)
- [Data Flow](#data-flow)

---

## Overview

The app displays a list of financial transactions loaded from a local JSON asset and allows the user to tap any transaction to view its full details.

**Screens:**
1. **Transaction History:** scrollable list of all transactions with type icon, customer name, date, and amount
2. **Transaction Details:** full detail card for a selected transaction

---

## Architecture

The project follows **Clean Architecture** with a strict dependency rule: inner layers never depend on outer layers.

```
┌────────────────────────────────────────────────┐
│               Presentation Layer               │
│   Pages · Widgets · BLoC (manager)             │
├────────────────────────────────────────────────┤
│                Domain Layer                    │
│   Entities · Repository (abstract) · Use Cases │
├────────────────────────────────────────────────┤
│                 Data Layer                     │
│   Models · Data Sources · Repository Impl      │
└────────────────────────────────────────────────┘
```

### Dependency rule
- **Domain** has zero Flutter/external dependencies, pure Dart.
- **Data** depends on Domain (implements its interfaces).
- **Presentation** depends on Domain use cases only; never touches data classes directly.

---

## Project Structure

```
lib/
├── core/
│   ├── di/
│   │   └── injection.dart             # Manual dependency injection container
│   ├── router/
│   │   └── app_router.dart            # go_router route definitions
│   ├── theme/
│   │   └── app_theme.dart             # Colors, text styles, button themes
│   └── widgets/                       # Shared UI components
│       ├── app_bottom_nav.dart
│       ├── outlined_card.dart
│       ├── primary_button.dart
│       └── section_header.dart
│
├── features/
│   └── transaction/
│       ├── data/
│       │   ├── data_sources/
│       │   │   └── transaction_local_data_source.dart   # Reads assets/transactions.json
│       │   ├── models/
│       │   │   ├── transaction_model.dart               # JSON-serializable model + entity mapping
│       │   │   └── transaction_model.g.dart             # Generated (do not edit)
│       │   └── repositories/
│       │       └── transaction_repository_impl.dart     # Concrete repository
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── transaction_entity.dart              # Pure Dart entity + TransactionType enum
│       │   ├── repositories/
│       │   │   └── transaction_repository.dart          # Abstract contract
│       │   └── usecases/
│       │       ├── get_transactions_usecase.dart
│       │       └── get_transaction_by_id_usecase.dart
│       │
│       └── presentation/
│           ├── manager/
│           │   ├── transaction_bloc.dart                # BLoC (events + states declared via part)
│           │   ├── transaction_event.dart
│           │   └── transaction_state.dart
│           ├── pages/
│           │   ├── transaction_history_page.dart
│           │   └── transaction_details_page.dart
│           └── widgets/
│               ├── transaction_list_item.dart
│               └── transaction_detail_card.dart
│
└── main.dart

test/
└── features/
    └── transaction/
        ├── data/
        │   ├── data_sources/   transaction_local_data_source_test.dart
        │   ├── models/         transaction_model_test.dart
        │   └── repositories/   transaction_repository_impl_test.dart
        ├── domain/
        │   └── usecases/       get_transactions_usecase_test.dart
        │                       get_transaction_by_id_usecase_test.dart
        └── presentation/
            ├── manager/        transaction_bloc_test.dart
            └── pages/          transaction_history_page_test.dart
                                transaction_details_page_test.dart

patrol_test/
└── transaction_flow_test.dart   # Patrol end-to-end tests

assets/
└── transactions.json            # Local fixture data
```

---

## Tech Stack

| Concern | Package | Version |
|---|---|---|
| State management | `flutter_bloc` | ^8.1.6 |
| Value equality | `equatable` | ^2.0.5 |
| Navigation | `go_router` | ^13.2.0 |
| JSON serialization | `json_annotation` + `json_serializable` | ^4.9.0 / ^6.9.5 |
| SVG icons | `flutter_svg` | ^2.0.10 |
| Date formatting | `intl` | ^0.19.0 |
| Unit/widget testing | `flutter_test` (SDK) | — |
| BLoC testing | `bloc_test` | ^9.1.7 |
| Mocking | `mocktail` | ^1.0.4 |
| Integration testing | `patrol` | ^4.5.0 |
| Code generation | `build_runner` | ^2.4.8 |

---

## Prerequisites

| Tool | Minimum version |
|---|---|
| Flutter SDK | 3.x (tested on 3.38.8) |
| Dart SDK | 3.9+ |
| Xcode (iOS/macOS) | 14+ |
| Android Studio / SDK | API 23+ |
| Patrol CLI (integration tests only) | `dart pub global activate patrol_cli 4.3.1` |

Check your environment:

```bash
flutter doctor
```

---

## Getting Started

### 1. Clone / open the project

```bash
cd demo-test
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run code generation

The `transaction_model.g.dart` file is produced by `json_serializable`. Re-run this any time you change a `@JsonSerializable` class:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous watching during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Running the App

### iOS Simulator

```bash
flutter run -d iPhone
```

### Android Emulator

```bash
flutter run -d emulator
```

### Specific device

```bash
flutter devices                 # list connected devices
flutter run -d <device-id>
```

### Release build

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```

---

## Running Tests

### Unit + Widget tests (fast, no device needed)

```bash
flutter test
```

Run a single test file:

```bash
flutter test test/features/transaction/presentation/manager/transaction_bloc_test.dart
```

Run with verbose output:

```bash
flutter test --reporter=expanded
```

Run with coverage:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Expected test output

```
All tests passed! (29 tests across 8 files)
```

Test breakdown:

| File | Tests | What is tested |
|---|---|---|
| `get_transactions_usecase_test` | 2 | Use case delegates to repository; propagates errors |
| `get_transaction_by_id_usecase_test` | 2 | Finds by id; throws `StateError` when missing |
| `transaction_model_test` | 4 | JSON parsing, serialization, `toEntity`, `fromEntity` |
| `transaction_local_data_source_test` | 3 | Asset loading, malformed JSON, asset errors |
| `transaction_repository_impl_test` | 4 | Maps models → entities; `StateError` on missing id |
| `transaction_bloc_test` | 5 | State transitions for all events (bloc_test) |
| `transaction_history_page_test` | 5 | Loading/loaded/empty/error UI; retry button dispatch |
| `transaction_details_page_test` | 3 | Loading/loaded/error UI |

### Integration tests (Patrol — requires physical device or simulator)

Install the Patrol CLI once:

```bash
dart pub global activate patrol_cli 4.3.1
```

Run integration tests:

```bash
# List connected devices first
flutter devices

# iOS
patrol test -t patrol_test/transaction_flow_test.dart -d <device-id>

# Android
patrol test -t patrol_test/transaction_flow_test.dart -d emulator-5554
```

Integration test scenarios:
1. Full flow: history list → tap item → detail screen → press back
2. All three fixture transactions are visible on the list screen
3. Detail screen shows correct amount and customer fields

---

## Design Decisions

### Why manual DI instead of get_it?

`Injection` is a simple static factory class. For an interview-scale app it is easier to trace than a service locator, avoids global mutable state, and keeps the dependency graph explicit and visible in one file.

### Why `AssetBundle` is injected into the data source

Injecting the bundle (instead of calling `rootBundle` directly) makes the data source fully unit-testable via a `MockAssetBundle` without touching the file system.

### Why `part` files for BLoC events/states

Using `part of` keeps the three BLoC files (bloc, event, state) as one logical unit while splitting them across files for readability, the same convention used in the official flutter_bloc documentation.

### Why `TransactionType` lives in the domain entity

The enum belongs to the domain because business rules (e.g. deposit vs withdrawal color coding) are domain concerns. The data layer maps JSON strings (`"Deposit"`) to the domain enum via a private `_typeFromJson` function in the model, keeping `json_annotation` out of the domain entirely.

### Why `Equatable` on entities

Value equality lets `BlocBuilder` detect state changes correctly (`TransactionsLoaded([a, b]) != TransactionsLoaded([a, b, c])`) without overriding `==` and `hashCode` by hand.

---

## Data Flow

```
User opens app
      │
      ▼
TransactionHistoryPage
  └─ BlocBuilder sees TransactionInitial
       └─ dispatches LoadTransactions
            │
            ▼
       TransactionBloc._onLoadTransactions
            │
            ▼
       GetTransactionsUseCase.call()
            │
            ▼
       TransactionRepositoryImpl.getTransactions()
            │
            ▼
       TransactionLocalDataSourceImpl.getTransactions()
            │   reads assets/transactions.json via AssetBundle
            ▼
       List<TransactionModel>  ──toEntity()──►  List<TransactionEntity>
            │
            ▼
       TransactionBloc emits TransactionsLoaded(transactions)
            │
            ▼
       BlocBuilder rebuilds → ListView shown

User taps a row
      │
      ▼
go_router pushes /transactions/:id
  └─ New BlocProvider + TransactionBloc created
       └─ TransactionDetailsPage dispatches LoadTransactionDetail(id)
            │
            ▼
       GetTransactionByIdUseCase.call(id)
            │   (filters from full list; throws StateError if missing)
            ▼
       TransactionBloc emits TransactionDetailLoaded(transaction)
            │
            ▼
       BlocBuilder rebuilds → TransactionDetailCard shown
```
