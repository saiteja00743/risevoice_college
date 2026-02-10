# Flutter + Backend Integration Guide

## 🔗 Connecting RiseVoice Flutter App to Backend API

This guide will help you integrate the Flutter frontend with the Node.js backend.

---

## 📋 Prerequisites

### Backend Setup
1. ✅ MongoDB running (local or Atlas)
2. ✅ Backend server running on `http://localhost:3000`
3. ✅ Email configured for OTP sending

### Flutter Setup
1. ✅ All dependencies installed (`flutter pub get`)
2. ✅ Update API base URL in constants

---

## 🔧 Step 1: Update API Base URL

### File: `lib/core/constants/app_constants.dart`

```dart
class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';  // For local testing
  // static const String baseUrl = 'http://10.0.2.2:3000/api';  // For Android emulator
  // static const String baseUrl = 'https://your-api.herokuapp.com/api';  // For production
  
  // ... rest of the constants
}
```

**Important Notes:**
- **Web/iOS Simulator**: Use `http://localhost:3000/api`
- **Android Emulator**: Use `http://10.0.2.2:3000/api` (10.0.2.2 is Android's localhost)
- **Real Device**: Use your computer's IP address (e.g., `http://192.168.1.100:3000/api`)
- **Production**: Use your deployed API URL

---

## 📁 Step 2: Create API Service Files

### Create: `lib/core/services/api_service.dart`

```dart
import 'package:dio/dio.dart';
import 'package:rise_voice/core/constants/app_constants.dart';
import 'package:rise_voice/core/security/secure_storage_service.dart';

class ApiService {
  late Dio _dio;
  final SecureStorageService _storage = SecureStorageService();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final token = await _storage.read(AppConstants.keyAuthToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors globally
          print('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
```

---

### Create: `lib/features/auth/data/repositories/auth_repository.dart`

```dart
import 'package:dio/dio.dart';
import 'package:rise_voice/core/services/api_service.dart';
import 'package:rise_voice/core/security/secure_storage_service.dart';
import 'package:rise_voice/core/constants/app_constants.dart';
import 'package:rise_voice/features/auth/domain/entities/user.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final SecureStorageService _storage = SecureStorageService();

  // Send OTP
  Future<Map<String, dynamic>> sendOTP(String email, String rollNumber) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/send-otp',
        data: {
          'email': email,
          'rollNumber': rollNumber,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Verify OTP
  Future<User> verifyOTP(String email, String rollNumber, String otp) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/verify-otp',
        data: {
          'email': email,
          'rollNumber': rollNumber,
          'otp': otp,
        },
      );

      // Save token
      await _storage.write(
        AppConstants.keyAuthToken,
        response.data['token'],
      );

      // Save user data
      await _storage.write(
        AppConstants.keyUserId,
        response.data['user']['id'],
      );

      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get current user
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiService.dio.get('/auth/me');
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Update profile
  Future<User> updateProfile({
    String? name,
    String? department,
    String? year,
  }) async {
    try {
      final response = await _apiService.dio.put(
        '/auth/profile',
        data: {
          if (name != null) 'name': name,
          if (department != null) 'department': department,
          if (year != null) 'year': year,
        },
      );
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.delete(AppConstants.keyAuthToken);
    await _storage.delete(AppConstants.keyUserId);
  }

  // Error handler
  String _handleError(DioException error) {
    if (error.response != null) {
      return error.response!.data['message'] ?? 'An error occurred';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Server is not responding. Please try again later.';
    } else {
      return 'Network error. Please check your connection.';
    }
  }
}
```

---

### Create: `lib/features/grievance/data/repositories/grievance_repository.dart`

```dart
import 'package:dio/dio.dart';
import 'package:rise_voice/core/services/api_service.dart';
import 'package:rise_voice/features/grievance/domain/entities/grievance.dart';

class GrievanceRepository {
  final ApiService _apiService = ApiService();

  // Create grievance
  Future<Grievance> createGrievance({
    required String title,
    required String description,
    required String category,
    bool isAnonymous = false,
    bool isEmergency = false,
    String? priority,
    List<String>? attachmentPaths,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'description': description,
        'category': category,
        'isAnonymous': isAnonymous,
        'isEmergency': isEmergency,
        if (priority != null) 'priority': priority,
      });

      // Add file attachments
      if (attachmentPaths != null && attachmentPaths.isNotEmpty) {
        for (var path in attachmentPaths) {
          formData.files.add(
            MapEntry(
              'attachments',
              await MultipartFile.fromFile(path),
            ),
          );
        }
      }

      final response = await _apiService.dio.post(
        '/grievances',
        data: formData,
      );

      return Grievance.fromJson(response.data['grievance']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get my grievances
  Future<List<Grievance>> getMyGrievances({
    String? status,
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/grievances/my',
        queryParameters: {
          if (status != null) 'status': status,
          if (category != null) 'category': category,
          'page': page,
          'limit': limit,
        },
      );

      return (response.data['grievances'] as List)
          .map((json) => Grievance.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get single grievance
  Future<Grievance> getGrievance(String id) async {
    try {
      final response = await _apiService.dio.get('/grievances/$id');
      return Grievance.fromJson(response.data['grievance']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get grievance statistics
  Future<Map<String, int>> getGrievanceStats() async {
    try {
      final response = await _apiService.dio.get('/grievances/stats');
      return Map<String, int>.from(response.data['stats']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handler
  String _handleError(DioException error) {
    if (error.response != null) {
      return error.response!.data['message'] ?? 'An error occurred';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else {
      return 'Network error. Please check your connection.';
    }
  }
}
```

---

## 🔄 Step 3: Create Riverpod Providers

### Create: `lib/features/auth/presentation/providers/auth_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rise_voice/features/auth/data/repositories/auth_repository.dart';
import 'package:rise_voice/features/auth/domain/entities/user.dart';

// Auth Repository Provider
final authRepositoryProvider = Provider((ref) => AuthRepository());

// Current User Provider
final currentUserProvider = FutureProvider<User?>((ref) async {
  try {
    final authRepo = ref.read(authRepositoryProvider);
    return await authRepo.getCurrentUser();
  } catch (e) {
    return null;
  }
});

// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

// Auth State
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState());

  Future<bool> sendOTP(String email, String rollNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.sendOTP(email, rollNumber);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String rollNumber, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.verifyOTP(email, rollNumber, otp);
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}
```

---

## 🎯 Step 4: Update Login Screen

### Update: `lib/features/auth/presentation/screens/login_screen.dart`

Add this to the login button's onPressed:

```dart
final authNotifier = ref.read(authStateProvider.notifier);

final success = await authNotifier.sendOTP(
  _emailController.text.trim(),
  _rollNumberController.text.trim(),
);

if (success && mounted) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OTPVerificationScreen(
        email: _emailController.text.trim(),
        rollNumber: _rollNumberController.text.trim(),
      ),
    ),
  );
} else {
  // Show error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(ref.read(authStateProvider).error ?? 'Failed to send OTP'),
      backgroundColor: Colors.red,
    ),
  );
}
```

---

## 🎯 Step 5: Update OTP Screen

### Update: `lib/features/auth/presentation/screens/otp_verification_screen.dart`

Add this to the verify button:

```dart
final authNotifier = ref.read(authStateProvider.notifier);

final success = await authNotifier.verifyOTP(
  widget.email,
  widget.rollNumber,
  otp,
);

if (success && mounted) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
} else {
  // Show error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(ref.read(authStateProvider).error ?? 'Invalid OTP'),
      backgroundColor: Colors.red,
    ),
  );
}
```

---

## 🧪 Step 6: Testing the Integration

### 1. Start Backend Server
```bash
cd backend
npm run dev
```

### 2. Start Flutter App
```bash
cd ..
flutter run -d chrome
```

### 3. Test Flow
1. Enter roll number and email
2. Click "Send OTP"
3. Check your email for OTP
4. Enter OTP
5. Should navigate to home screen

---

## 🐛 Common Issues & Solutions

### Issue 1: Connection Refused
**Error:** `DioException: Connection refused`

**Solution:**
- Check if backend is running
- Verify API base URL
- For Android emulator, use `10.0.2.2` instead of `localhost`

### Issue 2: CORS Error (Web)
**Error:** `Access to XMLHttpRequest has been blocked by CORS policy`

**Solution:**
Add your Flutter web URL to backend `.env`:
```env
ALLOWED_ORIGINS=http://localhost:8080,http://localhost:3000
```

### Issue 3: OTP Not Received
**Error:** Email not sending

**Solution:**
- Check email configuration in backend `.env`
- Verify Gmail app password
- Check backend logs for email errors
- In development, OTP is returned in API response

### Issue 4: Token Not Persisting
**Error:** User logged out after app restart

**Solution:**
- Verify SecureStorageService is saving token
- Check token is being added to API requests
- Implement auto-login on app start

---

## 📱 Step 7: Handle App Initialization

### Update: `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await EncryptionService.init();
  
  runApp(const ProviderScope(child: RiseVoiceApp()));
}

class RiseVoiceApp extends ConsumerWidget {
  const RiseVoiceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return MaterialApp(
      title: 'RiseVoice',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: currentUserAsync.when(
        data: (user) {
          // If user exists, go to home, else go to splash
          return user != null ? const HomeScreen() : const SplashScreen();
        },
        loading: () => const SplashScreen(),
        error: (_, __) => const SplashScreen(),
      ),
    );
  }
}
```

---

## 🚀 Production Checklist

Before deploying to production:

- [ ] Update API base URL to production URL
- [ ] Enable HTTPS
- [ ] Configure proper CORS origins
- [ ] Set strong JWT secret
- [ ] Enable error tracking (Sentry, etc.)
- [ ] Add retry logic for failed requests
- [ ] Implement proper loading states
- [ ] Add offline support
- [ ] Test on real devices
- [ ] Optimize API calls
- [ ] Add request caching

---

## 📚 Additional Resources

- [Dio Documentation](https://pub.dev/packages/dio)
- [Riverpod Documentation](https://riverpod.dev)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)

---

**Integration Complete! 🎉**

Your Flutter app is now connected to the backend API and ready for testing!
