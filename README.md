# 🔧 Fixora

> **Fixora** is a full-stack mobile application that connects users with skilled service providers for home repairs, maintenance, and on-demand services — all from a single, seamless app.

---

## 📱 Overview

Fixora provides a platform where users can browse, book, and manage service requests, while service providers can manage their availability, accept jobs, and grow their business. Built with Flutter for a smooth cross-platform experience and a robust Java backend to handle business logic and data.

---

## 🗂️ Project Structure

```
Fixora/
├── service_app/       # Flutter mobile app (User & Service Provider UI)
│   ├── lib/           # Dart source code
│   ├── android/       # Android-specific files
│   ├── ios/           # iOS-specific files
│   └── pubspec.yaml   # Flutter dependencies
├── backend/           # Java-based REST API backend
│   └── src/           # Server-side source code
└── .vscode/           # VS Code workspace settings
```

---

## 🛠️ Tech Stack

| Layer        | Technology                          |
|--------------|-------------------------------------|
| Mobile App   | Flutter (Dart)                      |
| Backend API  | Java                                |
| Platforms    | Android, iOS                        |
| Build Tools  | CMake, Gradle                       |

---

## ✨ Features

- 🔍 **Browse Services** — Explore a wide range of home and repair services
- 📅 **Easy Booking** — Schedule a service at your preferred time
- 👷 **Service Provider Profiles** — View ratings, reviews, and expertise
- 📍 **Location-Based Matching** — Find providers near you
- 🔔 **Real-Time Notifications** — Stay updated on booking status
- 💬 **In-App Messaging** — Chat directly with your service provider
- 💳 **Secure Payments** — Hassle-free payment processing
- ⭐ **Ratings & Reviews** — Rate your experience after each service

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (stable channel)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) (for iOS)
- [Java JDK 11+](https://www.oracle.com/java/technologies/javase-downloads.html)
- Git

---

## 📸 Screenshots

> *(Add screenshots of the app here)*

| Home Screen | Booking Screen | Provider Profile |
|-------------|---------------|-----------------|
| ![Home](#)  | ![Booking](#) | ![Profile](#)   |

---

### 📦 Clone the Repository

```bash
git clone https://github.com/prashant000000004/Fixora.git
cd Fixora
```

---

### 📱 Running the Flutter App

```bash
# Navigate to the Flutter app directory
cd service_app

# Install Flutter dependencies
flutter pub get

# Run the app on a connected device or emulator
flutter run
```

To build a release APK for Android:

```bash
flutter build apk --release
```

To build for iOS:

```bash
flutter build ios --release
```

---

### 🖥️ Running the Backend

```bash
# Navigate to the backend directory
cd backend

# Build the project (adjust based on your build tool)
./mvnw clean install       # Maven
# or
./gradlew build            # Gradle

# Run the server
./mvnw spring-boot:run     # Maven
# or
./gradlew bootRun          # Gradle
```

> ⚠️ Make sure to configure your environment variables (database URL, API keys, etc.) before starting the backend.

---

## ⚙️ Configuration

Create a `.env` file or configure `application.properties` / `application.yml` in the backend with the following:

```properties
# Database
DB_URL=your_database_url
DB_USERNAME=your_db_username
DB_PASSWORD=your_db_password

# App
SERVER_PORT=8080
JWT_SECRET=your_jwt_secret
```

Update the Flutter app's API base URL in the appropriate config file inside `service_app/lib/`.

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a new feature branch (`git checkout -b feature/your-feature`)
3. **Commit** your changes (`git commit -m 'Add your feature'`)
4. **Push** to the branch (`git push origin feature/your-feature`)
5. **Open** a Pull Request

Please make sure your code follows the project's coding style and that all tests pass before submitting a PR.

---

## 🐛 Issues

Found a bug or have a feature request? Please [open an issue](https://github.com/prashant000000004/Fixora/issues) with a clear description and steps to reproduce.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 👨‍💻 Author

**Prashant**
- GitHub: [@prashant000000004](https://github.com/prashant000000004)

---

<p align="center">Made with ❤️ using Flutter & Java</p>
