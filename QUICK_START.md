# RiseVoice - Quick Start Guide

## 🚀 Running the Application

### Option 1: Run on Chrome (Fastest for Testing)
```bash
cd d:\grevience
flutter run -d chrome
```

### Option 2: Run on Android Device/Emulator
```bash
# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### Option 3: Build APK for Android
```bash
# Debug APK (for testing)
flutter build apk --debug

# Release APK (for distribution)
flutter build apk --release --split-per-abi
```

## 📱 App Flow

### 1. First Launch
- **Splash Screen** (3 seconds) → Auto-navigates to Onboarding

### 2. Onboarding (4 Pages)
- Page 1: "Your Voice is Safe Here" - Security focus
- Page 2: "Anonymous Reporting" - Privacy protection
- Page 3: "Track Progress" - Real-time updates
- Page 4: "Transparent & Accountable" - Institutional trust
- **Skip** button or **Next** → Login

### 3. Authentication
- **Login Screen**: Enter Roll Number + Email
- **Send OTP** → OTP Verification Screen
- **OTP Screen**: Enter 6-digit code
- Auto-verify when complete → Home Dashboard

### 4. Home Dashboard (3 Tabs)
- **Home Tab**: 
  - Welcome card
  - Activity stats (Total, Pending, Resolved, In Progress)
  - Quick actions (Raise Grievance, Emergency, Track)
  - FAB: "Raise Grievance"
  
- **My Grievances Tab**:
  - Filter tabs: All, Pending, In Progress, Resolved
  - Grievance cards with status badges
  - Tap card → Grievance Detail
  
- **Profile Tab**:
  - User info
  - Settings (Privacy, Language, Theme)
  - Help & Support
  - Logout

### 5. Raise Grievance
- Toggle: Submit Anonymously (ON/OFF)
- Select Category (13 options)
- Enter Title (min 5 chars)
- Enter Description (min 20 chars)
- Add Attachments (optional): Images, Audio, PDF
- **Submit** → Success message → Back to Home

### 6. Emergency Grievance
- **Warning Banner**: Marked as URGENT
- Anonymous by default
- Limited categories (Safety, Harassment, Discrimination)
- Confirmation dialog before submission
- Immediate notification to committee

### 7. Grievance Detail
- Status card with color coding
- Full details (category, title, description)
- Attachments (downloadable)
- Timeline visualization
- Updates from committee
- **Chat** button (if not resolved)

## 🎨 UI Features

### Color Coding
- **Pending**: Orange (#F59E0B)
- **Under Review**: Blue (#3B82F6)
- **In Progress**: Teal (#0D9488)
- **Resolved**: Green (#10B981)
- **Rejected**: Red (#EF4444)

### Priority Levels
- **Low**: Green badge
- **Medium**: Orange badge
- **High**: Red badge
- **Urgent**: Red badge (Emergency only)

### Theme Support
- **Light Mode**: Clean white with blue accents
- **Dark Mode**: Dark blue-gray with bright accents
- **Auto**: Follows system preference

## 🔐 Security Features in Action

### 1. Anonymous Mode
- When enabled: No user ID attached to grievance
- Anonymous ID generated using secure hash
- Committee cannot see student identity
- Updates remain anonymous in chat

### 2. Encryption
- All grievances encrypted before storage
- Encryption notice shown on submission
- Secure transmission to backend

### 3. Biometric Login
- Toggle on Login screen
- Fingerprint/Face ID on next login
- Fallback to OTP if biometric fails

### 4. Screen Security
- Screenshots disabled on sensitive screens
- Screen recording prevented
- Secure flag on Android

## 📋 Test Data (Mock)

### Sample Grievances
1. **Library AC not working**
   - Category: Infrastructure
   - Status: Pending
   - Priority: Medium
   - Created: 2 days ago

2. **Harassment complaint**
   - Category: Ragging/Harassment
   - Status: Under Review
   - Priority: High
   - Anonymous: Yes
   - Created: 5 days ago

3. **Exam schedule conflict**
   - Category: Examination
   - Status: Resolved
   - Priority: Low
   - Created: 10 days ago

## 🛠️ Troubleshooting

### Issue: Dependencies not installed
```bash
flutter pub get
```

### Issue: Build errors
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Chrome not detected
```bash
# Enable web support
flutter config --enable-web
flutter devices
```

### Issue: Android build fails
```bash
# Check Android SDK
flutter doctor

# Accept licenses
flutter doctor --android-licenses
```

## 📱 Supported Platforms

- ✅ **Android** (API 21+) - Full support
- ✅ **iOS** (12.0+) - Full support
- ✅ **Web** (Chrome) - Testing only
- ⚠️ **Windows/Linux** - Limited support

## 🎯 Key Screens to Test

1. **Splash → Onboarding → Login** (First-time flow)
2. **Login → OTP → Home** (Authentication)
3. **Home → Raise Grievance → Submit** (Core feature)
4. **Home → My Grievances → Detail** (Tracking)
5. **Home → Emergency Grievance** (Urgent reporting)
6. **Profile → Settings** (Configuration)

## 💡 Tips

- Use **Skip** on onboarding for faster testing
- Mock OTP: Any 6 digits work (no backend yet)
- Anonymous toggle: Test both modes
- File picker: Works on mobile, limited on web
- Dark mode: Toggle in Profile → Theme

## 🔄 Current Limitations

- ⚠️ No backend integration (mock data only)
- ⚠️ OTP not actually sent (accepts any code)
- ⚠️ File uploads stored locally only
- ⚠️ Chat feature UI ready, not functional
- ⚠️ Admin dashboard not implemented
- ⚠️ Telugu language not added yet

## 📞 Next Steps

1. **Backend Setup**: Create REST API endpoints
2. **State Management**: Implement Riverpod providers
3. **Firebase**: Configure for OTP and notifications
4. **Testing**: Write unit and widget tests
5. **Deployment**: Build release APK

---

**Ready to run!** Execute `flutter run -d chrome` to see the app in action.
