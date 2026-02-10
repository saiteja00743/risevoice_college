# 🚀 Deploy RiseVoice Backend to Cloud (Free)

## ✅ Your backend will work 24/7 even when your laptop is off!

We'll use **Render.com** (Free tier) - No credit card required!

---

## 📋 What You Need

1. ✅ GitHub account
2. ✅ MongoDB Atlas account (free)
3. ✅ Render.com account (free)

---

## Step 1: Setup MongoDB Atlas (Cloud Database)

### 1.1 Create Account
1. Go to [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
2. Click "Try Free"
3. Sign up with Google/Email

### 1.2 Create Cluster
1. Choose **FREE** tier (M0)
2. Select region closest to you (e.g., Mumbai for India)
3. Cluster name: `risevoice-cluster`
4. Click "Create Cluster"

### 1.3 Create Database User
1. Click "Database Access" (left sidebar)
2. Click "Add New Database User"
3. Username: `risevoice`
4. Password: Generate secure password (save it!)
5. Database User Privileges: "Read and write to any database"
6. Click "Add User"

### 1.4 Whitelist IP Address
1. Click "Network Access" (left sidebar)
2. Click "Add IP Address"
3. Click "Allow Access from Anywhere" (0.0.0.0/0)
4. Click "Confirm"

### 1.5 Get Connection String
1. Click "Database" (left sidebar)
2. Click "Connect" on your cluster
3. Choose "Connect your application"
4. Copy connection string:
   ```
   mongodb+srv://risevoice:<password>@risevoice-cluster.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```
5. Replace `<password>` with your actual password
6. **Save this connection string!**

---

## Step 2: Push Code to GitHub

### 2.1 Initialize Git (if not already)
```bash
cd d:\grevience\backend

# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - RiseVoice Backend"
```

### 2.2 Create GitHub Repository
1. Go to [github.com](https://github.com)
2. Click "+" → "New repository"
3. Repository name: `risevoice-backend`
4. Make it **Private** (recommended)
5. Click "Create repository"

### 2.3 Push to GitHub
```bash
# Add remote
git remote add origin https://github.com/YOUR_USERNAME/risevoice-backend.git

# Push code
git branch -M main
git push -u origin main
```

---

## Step 3: Deploy to Render.com

### 3.1 Create Render Account
1. Go to [render.com](https://render.com)
2. Click "Get Started"
3. Sign up with GitHub

### 3.2 Create New Web Service
1. Click "New +" → "Web Service"
2. Connect your GitHub repository: `risevoice-backend`
3. Click "Connect"

### 3.3 Configure Service
Fill in these details:

**Basic Settings:**
- **Name**: `risevoice-api`
- **Region**: Choose closest to you
- **Branch**: `main`
- **Root Directory**: Leave empty
- **Runtime**: `Node`
- **Build Command**: `npm install`
- **Start Command**: `npm start`

**Instance Type:**
- Select **Free** tier

### 3.4 Add Environment Variables
Click "Advanced" → "Add Environment Variable"

Add these variables:

```
NODE_ENV = production
PORT = 3000
MONGODB_URI = mongodb+srv://risevoice:YOUR_PASSWORD@risevoice-cluster.xxxxx.mongodb.net/risevoice?retryWrites=true&w=majority
JWT_SECRET = risevoice-super-secret-production-key-2024-change-this
JWT_EXPIRE = 30d
ALLOWED_ORIGINS = *
RATE_LIMIT_WINDOW_MS = 900000
RATE_LIMIT_MAX_REQUESTS = 100
COLLEGE_NAME = Kakatiya Degree College (Autonomous)
COLLEGE_EMAIL = admin@kdcollege.edu.in
```

**Important:** Replace `YOUR_PASSWORD` in MONGODB_URI with your actual MongoDB password!

### 3.5 Deploy
1. Click "Create Web Service"
2. Wait 5-10 minutes for deployment
3. You'll get a URL like: `https://risevoice-api.onrender.com`

---

## Step 4: Test Your Deployed API

### 4.1 Test Health Endpoint
Open browser and visit:
```
https://risevoice-api.onrender.com/health
```

You should see:
```json
{
  "success": true,
  "message": "RiseVoice API is running"
}
```

### 4.2 Test Login Endpoint
Using curl or Postman:
```bash
curl -X POST https://risevoice-api.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","rollNumber":"21A01A0501"}'
```

Should return:
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {...}
}
```

---

## Step 5: Update Flutter App

### Update API URL in Flutter

**File:** `lib/core/constants/app_constants.dart`

```dart
class AppConstants {
  // API Configuration - PRODUCTION
  static const String baseUrl = 'https://risevoice-api.onrender.com/api';
  
  // ... rest of constants
}
```

That's it! Your Flutter app will now connect to the cloud backend!

---

## 🎯 Your Deployed URLs

After deployment, you'll have:

- **API Base URL**: `https://risevoice-api.onrender.com/api`
- **Health Check**: `https://risevoice-api.onrender.com/health`
- **Login**: `https://risevoice-api.onrender.com/api/auth/login`
- **Grievances**: `https://risevoice-api.onrender.com/api/grievances`

---

## 📊 Free Tier Limits

### Render.com Free Tier:
- ✅ 750 hours/month (enough for 24/7)
- ✅ Automatic HTTPS
- ✅ Auto-deploy on git push
- ⚠️ Sleeps after 15 min inactivity (wakes up in ~30 seconds)
- ⚠️ 512 MB RAM

### MongoDB Atlas Free Tier:
- ✅ 512 MB storage
- ✅ Shared cluster
- ✅ Enough for thousands of grievances

---

## 🔄 Auto-Deploy Updates

Whenever you update your code:

```bash
cd d:\grevience\backend

# Make changes to your code

# Commit and push
git add .
git commit -m "Updated feature X"
git push origin main
```

Render will **automatically redeploy** in 2-3 minutes!

---

## 🐛 Troubleshooting

### Issue: "Application failed to respond"
**Solution:** Check Render logs:
1. Go to Render dashboard
2. Click your service
3. Click "Logs" tab
4. Look for errors

### Issue: "MongoDB connection failed"
**Solution:** 
1. Check MONGODB_URI is correct
2. Verify password has no special characters
3. Check Network Access allows 0.0.0.0/0

### Issue: "Service sleeps after inactivity"
**Solution:** 
- Free tier sleeps after 15 min
- First request takes ~30 sec to wake up
- Upgrade to paid tier ($7/month) for always-on

---

## 💰 Cost Breakdown

| Service | Free Tier | Paid Tier |
|---------|-----------|-----------|
| **Render.com** | ✅ Free (sleeps) | $7/month (always-on) |
| **MongoDB Atlas** | ✅ Free (512MB) | $9/month (2GB) |
| **Total** | **$0/month** | **$16/month** |

**Recommendation:** Start with free tier, upgrade when you have users!

---

## 🎉 Success Checklist

- [ ] MongoDB Atlas cluster created
- [ ] Database user created
- [ ] Network access configured
- [ ] Code pushed to GitHub
- [ ] Render.com service created
- [ ] Environment variables set
- [ ] Deployment successful
- [ ] Health endpoint working
- [ ] Login endpoint working
- [ ] Flutter app updated with new URL

---

## 🚀 Alternative Free Hosting Options

If Render doesn't work, try these:

1. **Railway.app** - Similar to Render, very easy
2. **Fly.io** - Free tier, no sleep
3. **Cyclic.sh** - Serverless, free tier
4. **Heroku** - $5/month (no longer free)

---

## 📞 Need Help?

If deployment fails:
1. Check Render logs
2. Verify MongoDB connection string
3. Test locally first (`npm run dev`)
4. Check all environment variables are set

---

**Your backend will now run 24/7 in the cloud! 🎊**

Even when your laptop is off, students can:
- ✅ Login to the app
- ✅ Submit grievances
- ✅ Track status
- ✅ View updates

**Total setup time: ~30 minutes**
