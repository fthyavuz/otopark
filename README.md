# ParkMate — Parking Lot Management App

A fully offline, cross-platform (iOS & Android) parking lot management application built with Flutter. Designed for parking attendants working on tablets or phones — no internet connection required.

---

## Features

- **Vehicle Entry Tracking** — Record car entry with plate number and automatic timestamp
- **Turkish Plate Validation** — Validates Turkish license plate format (`[01–81] [1–3 letters] [2–4 digits]`) with a warning for non-standard (foreign) plates
- **Duplicate Plate Guard** — Prevents entering a plate that is already inside the parking lot
- **Automatic Cost Calculation** — Calculates the fee at exit based on elapsed time and the active tariff; no manual tariff selection needed at entry
- **Configurable Tariff Brackets** — Add, edit, or delete tariff tiers (e.g. 0–1 h, 1–2 h, 2–4 h, full day); old tariffs are archived for historical accuracy
- **Subscription (Abonman) Support** — Monthly subscribers with multiple plates per subscription; marked automatically at exit with no charge
- **Large Payment Display** — Full-screen, high-contrast payment screen designed to be shown directly to the customer
- **Reports** — View currently parked cars and revenue summaries (daily / weekly / monthly / yearly)
- **Fully Offline** — All data is stored locally on the device using SQLite; no server or internet connection needed

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Local Database | sqflite + Drift (typed ORM) |
| Navigation | go_router |
| State Management | Riverpod |
| Date & Locale | intl (Turkish locale) |
| Build | Flutter CLI |

---

## Tariff Logic

| Duration | Fee |
|---|---|
| 0 – 1 hour | 100 ₺ |
| 1 – 2 hours | 150 ₺ |
| 2 – 4 hours | 200 ₺ |
| Full day (4 h +) | 400 ₺ |
| Monthly subscription | 4.000 ₺ / month |

> Tariff amounts and brackets are fully configurable by the user inside the app.

---

## Screens

| Screen | Description |
|---|---|
| Dashboard | Quick stats: cars inside, today's revenue, quick-action buttons |
| Car Entry | Plate input with format validation and duplicate guard |
| Active Cars | List of all currently parked vehicles with elapsed time |
| Exit & Payment | Full-screen cost breakdown shown to the customer |
| Tariff Management | Add / edit / delete tariff brackets; view tariff history |
| Subscribers | Manage monthly subscribers and their plate numbers |
| Reports | Daily / weekly / monthly / yearly revenue summaries |

---

## Project Structure

```
lib/
├── main.dart
├── app/
│   ├── router.dart
│   └── theme.dart
├── database/
│   ├── database.dart
│   └── tables/
│       ├── tariffs.dart
│       ├── parking_records.dart
│       └── subscribers.dart
├── features/
│   ├── dashboard/
│   ├── entry/
│   ├── exit/
│   ├── active_cars/
│   ├── tariff/
│   ├── subscriber/
│   └── reports/
└── shared/
    ├── widgets/
    ├── utils/
    │   ├── plate_validator.dart
    │   └── cost_calculator.dart
    └── providers/
```

---

## Development Phases

| Phase | Scope |
|---|---|
| Phase 1 | Project setup, database schema, navigation skeleton, theme |
| Phase 2 | Tariff CRUD, car entry (validation + duplicate guard), active cars list |
| Phase 3 | Exit & payment screen, cost calculation engine, subscriber detection |
| Phase 4 | Subscriber management (multi-plate, expiry, renewal) |
| Phase 5 | Reports (live view + summaries + tariff history) |
| Phase 6 | Tablet layout optimization, Turkish locale polish, edge cases |

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.x
- Dart >= 3.x
- Android Studio or Xcode (for device builds)

### Run

```bash
flutter pub get
flutter run
```

### Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## License

MIT
