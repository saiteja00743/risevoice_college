# 🚀 Deploy to Railway.app (100% FREE!)

## ✅ Railway.app - Better than Render!

**Why Railway:**
- ✅ **$5 FREE credit every month** (enough for 24/7)
- ✅ No credit card required
- ✅ No sleep/wake delays
- ✅ Faster deployment
- ✅ Better free tier than Render

---

## 📋 What You Need

1. ✅ GitHub account
2. ✅ MongoDB Atlas (you already have this!)
3. ✅ Railway.app account (free)

---

## Step 1: Push Code to GitHub

### 1.1 Initialize Git (if not done)
```bash
cd d:\grevience\backend

# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "RiseVoice Backend - Ready for deployment"
```

### 1.2 Create GitHub Repository
1. Go to [github.com](https://github.com)
2. Click "+" → "New repository"
3. Repository name: `risevoice-backend`
4. Make it **Private** (recommended)
5. **Don't** initialize with README
6. Click "Create repository"

### 1.3 Push to GitHub
```bash
# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/risevoice-backend.git

# Push code
git branch -M main
git push -u origin main
```

---

## Step 2: Deploy to Railway.app

### 2.1 Create Railway Account
1. Go to [railway.app](https://railway.app)
2. Click "Login"
3. Sign up with **GitHub** (easiest)
4. Verify your email

### 2.2 Create New Project
1. Click "New Project"
2. Select "Deploy from GitHub repo"
3. Choose your repository: `risevoice-backend`
4. Click "Deploy Now"

### 2.3 Add Environment Variables
1. Click on your deployed service
2. Go to "Variables" tab
3. Click "New Variable"
4. Add these variables one by one:

```
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb+srv://gajavellisaiteja123_db_user:aFlTmjKN69L5t6JT@risevoicecluster.yfsc6p9.mongodb.net/risevoice?retryWrites=true&w=majority&appName=risevoicecluster
JWT_SECRET=risevoice-production-secret-key-2024-railway
JWT_EXPIRE=30d
ALLOWED_ORIGINS=*
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
COLLEGE_NAME=Kakatiya Degree College (Autonomous)
COLLEGE_EMAIL=admin@kdcollege.edu.in
```

### 2.4 Deploy!
1. Railway will automatically deploy
2. Wait 2-3 minutes
3. You'll get a URL like: `https://risevoice-backend-production.up.railway.app`

### 2.5 Generate Public URL
1. Click "Settings" tab
2. Scroll to "Networking"
3. Click "Generate Domain"
4. You'll get: `https://your-project.up.railway.app`

---

## Step 3: Test Your Deployment

### 3.1 Test Health Endpoint
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

### 3.2 Test Login
Using curl or Postman:
```bash
curl -X POST https://your-project.up.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","rollNumber":"21A01A0501"}'
```

Should return:
```json
{
  "success": true,
  "token": "...",
  "user": {...}
}
```

---

## Step 4: Update Flutter App

**File:** `lib/core/constants/app_constants.dart`

```dart
class AppConstants {
  // Production API URL
  static const String baseUrl = 'https://your-project.up.railway.app/api';
  
  // ... rest of constants
}
```

---

## 🎯 Your Deployed URLs

After deployment:

- **Base URL**: `https://your-project.up.railway.app`
- **API**: `https://your-project.up.railway.app/api`
- **Health**: `https://your-project.up.railway.app/health`
- **Login**: `https://your-project.up.railway.app/api/auth/login`

---

## 💰 Railway Free Tier

### What You Get FREE:
- ✅ **$5 credit every month**
- ✅ ~500 hours of runtime (enough for 24/7)
- ✅ 512 MB RAM
- ✅ 1 GB Disk
- ✅ **No sleep** (always on!)
- ✅ Automatic HTTPS
- ✅ Auto-deploy on git push

### Cost Breakdown:
- **Free tier**: $5 credit/month
- **Usage**: ~$3-4/month for small app
- **Your cost**: **$0** (covered by free credit!)

---

## 🔄 Auto-Deploy Updates

Whenever you update code:

```bash
cd d:\grevience\backend

# Make your changes

# Commit and push
git add .
git commit -m "Updated feature"
git push origin main
```

**Railway automatically redeploys in 1-2 minutes!**

---

## 📊 Monitor Your App

### Railway Dashboard:
1. Go to [railway.app](https://railway.app)
2. Click your project
3. See:
   - Deployment status
   - Logs (real-time)
   - Metrics (CPU, RAM, Network)
   - Build history

### View Logs:
1. Click "Deployments" tab
2. Click latest deployment
3. Click "View Logs"
4. See real-time server logs

---

## 🐛 Troubleshooting

### Issue: "Build Failed"
**Solution:**
1. Check Railway logs
2. Verify `package.json` has correct scripts:
   ```json
   {
     "scripts": {
       "start": "node src/server.js"
     }
   }
   ```

### Issue: "Application Error"
**Solution:**
1. Check environment variables are set
2. Verify MONGODB_URI is correct
3. Check logs for errors

### Issue: "Cannot connect to database"
**Solution:**
1. Verify MongoDB Atlas connection string
2. Check Network Access in MongoDB Atlas
3. Ensure 0.0.0.0/0 is whitelisted

---

## 🎉 Alternative Free Options

If Railway doesn't work, try these:

### 1. **Fly.io** (Free Tier)
- 3 shared-cpu VMs
- 256 MB RAM each
- No credit card needed
- [fly.io](https://fly.io)

### 2. **Cyclic.sh** (Serverless)
- Unlimited deployments
- Auto-scaling
- Free tier forever
- [cyclic.sh](https://cyclic.sh)

### 3. **Vercel** (For Node.js)
- Serverless functions
- Free hobby tier
- Fast deployments
- [vercel.com](https://vercel.com)

---

## 📝 Quick Comparison

| Service | Free Tier | Sleep | Deployment |
|---------|-----------|-------|------------|
| **Railway** | ✅ $5/month | ❌ No | 2 min |
| **Render** | ❌ Paid only | ✅ Yes | 5 min |
| **Fly.io** | ✅ Free | ❌ No | 3 min |
| **Cyclic** | ✅ Free | ❌ No | 2 min |
| **Vercel** | ✅ Free | ❌ No | 1 min |

**Recommendation: Railway.app** (best free tier!)

---

## ✅ Success Checklist

- [ ] Code pushed to GitHub
- [ ] Railway.app account created
- [ ] Project deployed
- [ ] Environment variables set
- [ ] Public domain generated
- [ ] Health endpoint working
- [ ] Login endpoint working
- [ ] Flutter app updated with URL
- [ ] Tested complete flow

---

## 🚀 Deployment Time

**Total time: ~15 minutes**

1. Push to GitHub: 5 min
2. Deploy to Railway: 5 min
3. Test & verify: 5 min

---

## 🎊 After Deployment

Your app will:
- ✅ Run 24/7 (no sleep!)
- ✅ Work when laptop is off
- ✅ Auto-deploy on code changes
- ✅ Have HTTPS enabled
- ✅ Be production-ready

**Cost: $0/month** (covered by free credit!)

---

## 📞 Need Help?

### Railway Support:
- [Railway Docs](https://docs.railway.app)
- [Railway Discord](https://discord.gg/railway)
- [Railway Status](https://railway.statuspage.io)

### Common Issues:
1. **Build fails** → Check package.json scripts
2. **Can't connect** → Check environment variables
3. **Database error** → Verify MongoDB URI

---

**Ready to deploy? Follow the steps above!** 🚀

**Railway.app is the best free option - no credit card, no sleep, $5 free credit every month!**
