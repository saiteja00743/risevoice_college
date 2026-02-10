# RiseVoice 🎯

**A Secure, Privacy-First College Grievance Redressal Platform**

Built for **Kakatiya Degree College (Autonomous), Hanamkonda**

---

## 📱 Overview

RiseVoice is a Flutter-based mobile application that enables students to raise grievances safely, anonymously, and confidently, while ensuring transparency and accountability for college authorities.

### ✨ Key Features

- 🔐 **Secure Authentication** - Roll Number + OTP (Email/SMS)
- 👆 **Biometric Login** - Fingerprint/Face ID support
- 🕵️ **Anonymous Reporting** - Complete identity protection
- 🔒 **End-to-End Encryption** - Secure grievance submission
- 📊 **Real-Time Tracking** - Monitor grievance status
- 💬 **Secure Chat** - Anonymous communication with committee
- 🚨 **Emergency Grievances** - Urgent issue reporting
- 🌓 **Dark Mode** - Light and dark theme support
- 🌍 **Multi-Language** - English + Telugu support

---

## 🏗️ Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/
│   ├── constants/      # App-wide constants
│   ├── theme/          # Theme configuration
│   ├── security/       # Encryption & security services
│   ├── utils/          # Utility functions
│   └── widgets/        # Reusable widgets
│
├── features/
│   ├── auth/
│   │   ├── data/           # Data models & repositories
│   │   ├── domain/         # Business logic & entities
│   │   └── presentation/   # UI screens & widgets
│   │
│   ├── grievance/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── dashboard/
│   ├── admin/
│   └── chat/
│
└── main.dart
```

---

## 🛠️ Tech Stack

### Core
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Riverpod
- **Design System**: Material 3

### Security
- **Encryption**: AES-256 encryption
- **Storage**: Flutter Secure Storage
- **Biometric**: Local Authentication
- **Screen Security**: Screenshot prevention

### Backend Integration
- **HTTP Client**: Dio + Retrofit
- **Authentication**: JWT tokens
- **File Upload**: Multipart requests

### Local Storage
- **Database**: Hive (encrypted)
- **Cache**: Path Provider

### UI/UX
- **Fonts**: Google Fonts (Inter)
- **Icons**: Material Icons
- **Animations**: Lottie, Custom animations

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.2.0)
- Dart SDK (>=3.2.0)
- Android Studio / VS Code
- Android SDK (API 21+)
- iOS 12.0+ (for iOS builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd rise_voice
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android
   flutter run

   # For Chrome (Web)
   flutter run -d chrome

   # For specific device
   flutter devices
   flutter run -d <device-id>
   ```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs by ABI
flutter build apk --split-per-abi
```

---

## 🔐 Security Features

### 1. **End-to-End Encryption**
- All grievances are encrypted using AES-256 before transmission
- Encryption keys are securely stored using Flutter Secure Storage

### 2. **Anonymous Mode**
- Zero identity exposure for anonymous submissions
- Anonymous IDs generated using secure hashing

### 3. **Biometric Authentication**
- Optional fingerprint/face ID login
- Secure local authentication

### 4. **Screen Security**
- Screenshot prevention on sensitive screens
- Screen recording disabled for privacy

### 5. **Secure Storage**
- JWT tokens stored in encrypted storage
- Draft grievances saved securely offline

---

## 👥 User Roles

### 1. **Student**
- Raise grievances (normal & emergency)
- Track grievance status
- Chat with committee (anonymous supported)
- View resolution timeline

### 2. **Grievance Committee Member**
- View assigned grievances
- Update grievance status
- Respond to students
- Mark grievances as resolved

### 3. **College Admin**
- Dashboard with analytics
- Assign grievances to committee
- View audit logs
- Generate reports

---

## 📋 Grievance Categories

- Academic Issues
- Infrastructure
- Faculty Behavior
- Examination
- Library
- Hostel
- Canteen
- Transportation
- Ragging/Harassment
- Discrimination
- Safety & Security
- Administrative
- Other

---

## 🎨 Design System

### Color Palette

**Primary Colors**
- Primary Blue: `#2563EB`
- Primary Teal: `#0D9488`
- Accent Cyan: `#06B6D4`

**Semantic Colors**
- Success: `#10B981`
- Warning: `#F59E0B`
- Error: `#EF4444`
- Info: `#3B82F6`

### Typography
- **Font Family**: Inter (Google Fonts)
- **Heading**: Bold, 24-32px
- **Body**: Regular, 14-16px
- **Caption**: Regular, 12px

---

## 📱 Screens

### Authentication Flow
1. **Splash Screen** - App branding
2. **Onboarding** - Feature introduction
3. **Login** - Roll number + Email
4. **OTP Verification** - 6-digit OTP

### Student Flow
1. **Home Dashboard** - Stats & quick actions
2. **Raise Grievance** - Submit new complaint
3. **My Grievances** - View all submissions
4. **Grievance Detail** - Track status & updates
5. **Emergency Grievance** - Urgent reporting
6. **Chat** - Communicate with committee
7. **Profile** - Settings & preferences

### Admin Flow
1. **Admin Dashboard** - Overview & analytics
2. **Grievance Management** - Assign & respond
3. **Reports** - Generate insights
4. **Audit Logs** - Track all actions

---

## 🔧 Configuration

### Backend API

Update the base URL in `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'https://api.risevoice.edu.in';
```

### Firebase (Optional)

For OTP and push notifications, configure Firebase:

1. Add `google-services.json` to `android/app/`
2. Add `GoogleService-Info.plist` to `ios/Runner/`
3. Initialize Firebase in `main.dart`

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/features/auth/login_test.dart
```

---

## 📦 Dependencies

Key packages used:

- `flutter_riverpod` - State management
- `google_fonts` - Typography
- `flutter_secure_storage` - Encrypted storage
- `local_auth` - Biometric authentication
- `encrypt` - AES encryption
- `dio` - HTTP client
- `file_picker` - File selection
- `image_picker` - Camera access
- `fl_chart` - Charts & analytics

See `pubspec.yaml` for complete list.

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👨‍💻 Development Team

**Kakatiya Degree College (Autonomous)**  
Hanamkonda, Telangana

---

## 📞 Support

For support, email: support@risevoice.edu.in

---

## 🙏 Acknowledgments

- Kakatiya Degree College Administration
- Student Community
- Flutter Community

---

**Made with ❤️ for student welfare and institutional transparency**
