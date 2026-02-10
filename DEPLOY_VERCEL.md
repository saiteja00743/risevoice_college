# 🚀 Deploy to Vercel (Free Forever)

Vercel is the most stable free hosting platform. We have configured your backend to run as a **Serverless API**, meaning it is free forever for personal use.

---

## 📋 Steps to Deploy

### 1. Push Code to GitHub
Ensure you have committed the new `vercel.json` file I just created:
```bash
cd d:\grevience\backend
git add .
git commit -m "Add Vercel configuration"
git push origin main
```

### 2. Import to Vercel
1.  Go to [Vercel.com](https://vercel.com/).
2.  Sign in with GitHub.
3.  Click **Add New** -> **Project**.
4.  Select your `risevoice-backend` repository.
5.  **Project Name**: `risevoice-api`
6.  **Root Directory**: Set this to `backend` (if you are deploying from a monorepo).
7.  **Environment Variables**:
    *   Add `MONGODB_URI` from your Atlas dashboard.
    *   Add `JWT_SECRET` (any random string).
    *   Add `ALLOWED_ORIGINS` as `*`.
    *   Add `NODE_ENV` as `production`.

### 3. Deploy
1.  Click **Deploy**.
2.  Once finished, you will get a URL like `https://risevoice-api.vercel.app`.

---

## 📱 Update Flutter
Open `lib/core/constants/app_constants.dart` and update the base URL:
```dart
static const String baseUrl = 'https://risevoice-api.vercel.app/api';
```

---

## 💡 Pro Tip
Vercel is **serverless**. This means the server "wakes up" when someone uses the app. If you don't use the app for a few hours, the first request might take 2-3 seconds to load, but after that, it is lightning fast. Everything will work perfectly while your laptop is off!
