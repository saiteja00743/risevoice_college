# 🚀 Deploy to Koyeb (Truly Free)

## Why Koyeb?
* ✅ **Free Forever Tier**: 1 Nano instance is free.
* ✅ **No Sleep**: It doesn't spin down like Render, so your first request is always fast.
* ✅ **No Credit Card**: You can start without entering payment info.

---

## 📋 Steps to Deploy

### 1. GitHub Preparation
Ensure your `package.json` has a `start` script:
```json
"scripts": {
  "start": "node src/server.js",
  "dev": "nodemon src/server.js"
}
```
*Note: I have already set this up for you.*

### 2. Connect to Koyeb
1. Login to [Koyeb](https://app.koyeb.com/) using GitHub.
2. Click **Create Service**.
3. Select **GitHub** and authorize Koyeb to access your `risevoice-backend` repo.
4. Choose the repository and the branch (`main`).

### 3. Configure
* **Instance Type**: Select **Nano** (Free).
* **Region**: Choose the one closest to you (e.g., Frankfurt or Washington D.C.).
* **Build Strategy**: Select **Buildpack**.

### 4. Environment Variables
Add these in the "Variables" section:
* `NODE_ENV`: `production`
* `PORT`: `8080` (Koyeb default for buildpacks)
* `MONGODB_URI`: `mongodb+srv://gajavellisaiteja123_db_user:aFlTmjKN69L5t6JT@risevoicecluster.yfsc6p9.mongodb.net/risevoice?retryWrites=true&w=majority&appName=risevoicecluster`
* `JWT_SECRET`: `risevoice_prod_secret_2024`
* `JWT_EXPIRE`: `30d`
* `ALLOWED_ORIGINS`: `*`

### 5. Finalize
1. Click **Deploy**.
2. Once the health check turns green, your app is live!
3. Your URL will look like: `https://your-app-name.koyeb.app`

---

## 📱 Update Flutter Constants
Go to `lib/core/constants/app_constants.dart` and update:
```dart
static const String baseUrl = 'https://your-app-name.koyeb.app/api';
```
