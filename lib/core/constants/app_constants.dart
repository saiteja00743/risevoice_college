class AppConstants {
  // App Info
  static const String appName = 'RiseVoice';
  static const String appTagline = 'Your voice is safe here';
  static const String collegeName = 'Kakatiya Degree College (Autonomous)';
  static const String collegeLocation = 'Hanamkonda';
  
  // API Endpoints
  static const String baseUrl = 'https://risevoice-college.vercel.app/api';
  static const String apiVersion = ''; // Already included in baseUrl
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Grievance Categories
  static const List<String> grievanceCategories = [
    'Academic Issues',
    'Infrastructure',
    'Faculty Behavior',
    'Examination',
    'Library',
    'Hostel',
    'Canteen',
    'Transportation',
    'Ragging/Harassment',
    'Discrimination',
    'Safety & Security',
    'Administrative',
    'Other',
  ];
  
  // Grievance Status
  static const String statusPending = 'pending';
  static const String statusUnderReview = 'under_review';
  static const String statusInProgress = 'in_progress';
  static const String statusResolved = 'resolved';
  static const String statusRejected = 'rejected';
  
  // Priority Levels
  static const String priorityLow = 'low';
  static const String priorityMedium = 'medium';
  static const String priorityHigh = 'high';
  static const String priorityUrgent = 'urgent';
  
  // User Roles
  static const String roleStudent = 'student';
  static const String roleCommittee = 'committee';
  static const String roleAdmin = 'admin';
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = [
    'jpg',
    'jpeg',
    'png',
    'pdf',
    'mp3',
    'wav',
    'm4a',
  ];
  
  // Validation
  static const int minDescriptionLength = 20;
  static const int maxDescriptionLength = 2000;
  static const int otpLength = 6;
  static const int otpExpiryMinutes = 5;
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Languages
  static const String langEnglish = 'en';
  static const String langTelugu = 'te';
}
