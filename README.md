# Iron Path Mobile

A local-first, privacy-focused workout tracking application built with Flutter.

## 🚀 Features

-   **Workout Tracking**: Real-time session tracking with rest timers and set logging.
-   **Program Management**: Built-in PPL splits and custom routine builder.
-   **Analytics**: Visualize progress with 1RM charts and weekly volume states.
-   **Offline First**: All data is stored locally using Hive.
-   **Notifications**: Background rest timer alerts.

## 🛠️ Tech Stack

-   **Framework**: Flutter
-   **State Management**: Riverpod (MVVM Architecture)
-   **Persistence**: Hive (NoSQL)
-   **Navigation**: GoRouter
-   **Charts**: fl_chart

## 🏃‍♂️ Getting Started

### Prerequisites

-   Flutter SDK (^3.6.1)
-   Dart SDK

### Installation

1.  Clone the repository and navigate to the project:
    ```bash
    cd iron_path_mobile
    ```

2.  Install dependencies:
    ```bash
    flutter pub get
    ```

3.  Run the code generator (required for Hive adapters and Riverpod providers):
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  Run the app:
    ```bash
    flutter run
    ```

## 🧪 Testing

To run the test suite (Unit & Widget tests):

```bash
flutter test
```

## 📂 Project Structure

-   `lib/models/`: Hive data models.
-   `lib/views/`: UI Screens and ViewModels.
-   `lib/services/`: Core services (Auth, Storage, Notifications).
-   `lib/theme/`: App styling and theme definition.

## 📄 License

This project is for personal use and portfolio demonstration.
