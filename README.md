# 🔧 Fixora (FixNow)

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
│   ├── assets/        # Images, icons, and screenshots
│   ├── android/       # Android-specific files
│   ├── ios/           # iOS-specific files
│   └── pubspec.yaml   # Flutter dependencies
├── backend/           # Java-based REST API backend
│   └── src/           # Server-side source code
└── .vscode/           # VS Code workspace settings
```

---

## 🛠️ Tech Stack

| Layer        | Technology       |
|--------------|------------------|
| Mobile App   | Flutter (Dart)   |
| Backend API  | Java             |
| Platforms    | Android, iOS     |
| Build Tools  | CMake, Gradle    |

---

## ✨ Features

### 👤 For Customers
- 🔍 **Smart Search** — Search by problem description or service type with live suggestions
- 🗂️ **Browse Services** — Electrical, Plumbing, Carpentry, Cleaning, AC Repair, Painting, Pest Control, Appliance repair & more
- 👷 **Provider Profiles** — View ratings, reviews, skills, experience, and verified badges
- 📅 **4-Step Booking Flow** — Schedule → Address → Details → Summary & Confirm
- 📍 **Location-Based Matching** — Find providers near you with distance shown in km
- 🔔 **Real-Time Notifications** — Booking confirmations, provider ETA, payment updates, and special offers
- 💾 **Saved Providers** — Bookmark your favourite service providers for quick rebooking
- 🏠 **Saved Addresses** — Store multiple addresses with GPS capture for faster booking
- 📋 **My Bookings** — Track Upcoming, Ongoing, Completed, and Cancelled bookings
- 🎁 **Refer & Earn** — Share referral codes and earn ₹200 per successful referral
- 🤝 **Help & Support** — Live Chat, Email, and Call support with built-in FAQ

### 🔧 For Service Providers
- 🟢 **Online / Offline Toggle** — Go online to start receiving job requests instantly
- 📊 **Earnings Dashboard** — View today's earnings and total jobs completed
- 📬 **New Job Requests** — See pending requests with distance, service type, and estimated payout
- ✅ **Job Lifecycle Tracking** — Step-by-step: Accepted → On the Way → Arrived → Work Started → Completed
- ⏱️ **Live Work Timer** — Built-in timer that starts when work begins
- 💰 **Instant Payout Summary** — See earnings per job upon completion

---

## 📸 Screenshots

### 🚀 Onboarding

<table>
  <tr>
    <td align="center"><b>Splash Screen</b></td>
    <td align="center"><b>Sign In</b></td>
    <td align="center"><b>Register</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132646.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132648.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132650.jpg" width="220"/></td>
  </tr>
</table>

---

### 🔧 Service Provider Side

<table>
  <tr>
    <td align="center"><b>Dashboard (Offline)</b></td>
    <td align="center"><b>Dashboard (Online + New Requests)</b></td>
    <td align="center"><b>New Job Request Detail</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132813.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132817.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132821.jpg" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><b>Active Job — Accepted</b></td>
    <td align="center"><b>Active Job — On the Way</b></td>
    <td align="center"><b>Active Job — Arrived</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132825.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132827.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132829.jpg" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><b>Active Job — Work Started (Live Timer)</b></td>
    <td align="center"><b>Job Completed!</b></td>
    <td align="center"><b>Provider Notifications</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132831.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132834.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132842.jpg" width="220"/></td>
  </tr>
</table>

---

### 🏠 Customer — Home & Search

<table>
  <tr>
    <td align="center"><b>Home (Services Grid)</b></td>
    <td align="center"><b>Search (Popular Searches)</b></td>
    <td align="center"><b>Search Results (AC Service)</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132923.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133200.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133026.jpg" width="220"/></td>
  </tr>
</table>

---

### 🗂️ Customer — Service Category & Providers

<table>
  <tr>
    <td align="center"><b>AC Repair — Services List</b></td>
    <td align="center"><b>Available Providers (Filtered)</b></td>
    <td align="center"><b>Provider Profile & Reviews</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133030.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133033.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133141.jpg" width="220"/></td>
  </tr>
</table>

---

### 📅 Customer — Booking Flow (4 Steps)

<table>
  <tr>
    <td align="center"><b>Step 1 — Schedule (Date & Time)</b></td>
    <td align="center"><b>Step 2 — Select Address</b></td>
    <td align="center"><b>Step 2 — Add New Address (GPS)</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133039.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133043.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133110.jpg" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><b>Step 2 — Address Saved</b></td>
    <td align="center"><b>Step 3 — Job Description & Photos</b></td>
    <td align="center"><b>Step 4 — Booking Summary</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133114.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133117.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133119.jpg" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><b>Booking Confirmed! 🎉</b></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133122.jpg" width="220"/></td>
    <td></td>
    <td></td>
  </tr>
</table>

---

### 👤 Customer — Profile & Account

<table>
  <tr>
    <td align="center"><b>Profile</b></td>
    <td align="center"><b>Saved Addresses</b></td>
    <td align="center"><b>Saved Providers</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132938.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132940.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132947.jpg" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><b>My Bookings — Upcoming</b></td>
    <td align="center"><b>My Bookings — Ongoing</b></td>
    <td align="center"><b>Refer & Earn</b></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132953.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132957.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133006.jpg" width="220"/></td>
  </tr>
</table>

---

### 🔔 Notifications & Support

<table>
  <tr>
    <td align="center"><b>Customer Notifications</b></td>
    <td align="center"><b>Help & Support</b></td>
    <td></td>
  </tr>
  <tr>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_132934.jpg" width="220"/></td>
    <td><img src="service_app/assets/github_ss/Screenshot_20260329_133003.jpg" width="220"/></td>
    <td></td>
  </tr>
</table>

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

# Build and run (Maven)
./mvnw clean install
./mvnw spring-boot:run

# Or with Gradle
./gradlew build
./gradlew bootRun
```

> ⚠️ Make sure to configure your environment variables (database URL, API keys, etc.) before starting the backend.

---

## ⚙️ Configuration

Configure `application.properties` or `application.yml` in the backend:

```properties
# Database
DB_URL=your_database_url
DB_USERNAME=your_db_username
DB_PASSWORD=your_db_password

# App
SERVER_PORT=8080
JWT_SECRET=your_jwt_secret
```

Update the Flutter app's API base URL inside `service_app/lib/`.

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a new feature branch (`git checkout -b feature/your-feature`)
3. **Commit** your changes (`git commit -m 'Add your feature'`)
4. **Push** to the branch (`git push origin feature/your-feature`)
5. **Open** a Pull Request

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
