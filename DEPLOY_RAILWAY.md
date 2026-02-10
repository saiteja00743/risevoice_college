# 🚀 Quick Deploy Guide - Railway.app

## ✅ Railway.app - 100% FREE!

**Best free hosting for your backend!**

- ✅ $5 free credit every month
- ✅ No credit card needed
- ✅ No sleep (always on!)
- ✅ Auto-deploy from GitHub

---

## 🎯 Quick Steps (15 minutes)

### 1. Push to GitHub (5 min)

```bash
cd d:\grevience\backend

# Initialize git
git init
git add .
git commit -m "RiseVoice Backend"

# Create repo on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/risevoice-backend.git
git push -u origin main
```

### 2. Deploy to Railway (5 min)

1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Choose `risevoice-backend`
6. Click "Deploy Now"

### 3. Add Environment Variables (3 min)

Click "Variables" tab, add these:

```
NODE_ENV=production
MONGODB_URI=mongodb+srv://gajavellisaiteja123_db_user:aFlTmjKN69L5t6JT@risevoicecluster.yfsc6p9.mongodb.net/risevoice?retryWrites=true&w=majority&appName=risevoicecluster
JWT_SECRET=risevoice-production-key-2024
JWT_EXPIRE=30d
ALLOWED_ORIGINS=*
```

### 4. Generate Public URL (1 min)

1. Click "Settings" tab
2. Scroll to "Networking"
3. Click "Generate Domain"
4. Get URL: `https://your-project.up.railway.app`

### 5. Test (1 min)

Open browser:
```
https://your-project.up.railway.app/health
```

Should see:
```json
{
  "success": true,
  "message": "RiseVoice API is running"
}
```

---

## 📱 Update Flutter App

**File:** `lib/core/constants/app_constants.dart`

```dart
static const String baseUrl = 'https://your-project.up.railway.app/api';
```

---

## 🎉 Done!

Your app now works **24/7** even when laptop is off!

**Cost: $0/month** (free credit covers it!)

---

## 🔄 Update Your App

```bash
# Make changes
git add .
git commit -m "Update"
git push

# Railway auto-deploys in 2 minutes!
```

---

## 💡 Alternative Free Options

If Railway doesn't work:

1. **Fly.io** - [fly.io](https://fly.io)
2. **Cyclic.sh** - [cyclic.sh](https://cyclic.sh)
3. **Vercel** - [vercel.com](https://vercel.com)

All are 100% free!

---

**Full guide: `CLOUD_DEPLOYMENT.md`**
