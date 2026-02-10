# RiseVoice Backend API

## 🚀 Quick Start

### Prerequisites
- Node.js (v16 or higher)
- MongoDB (local or Atlas)
- npm or yarn

### Installation

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   ```bash
   # Copy .env.example to .env
   cp .env.example .env
   
   # Edit .env and update values
   ```

4. **Start MongoDB** (if using local)
   ```bash
   mongod
   ```

5. **Run the server**
   ```bash
   # Development mode (with auto-reload)
   npm run dev
   
   # Production mode
   npm start
   ```

The server will start at `http://localhost:3000`

---

## 📁 Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # MongoDB connection
│   ├── controllers/
│   │   ├── authController.js    # Authentication logic
│   │   └── grievanceController.js # Grievance CRUD
│   ├── middleware/
│   │   └── auth.js              # JWT verification
│   ├── models/
│   │   ├── User.js              # User schema
│   │   ├── Grievance.js         # Grievance schema
│   │   └── OTP.js               # OTP schema
│   ├── routes/
│   │   ├── auth.js              # Auth routes
│   │   └── grievances.js        # Grievance routes
│   ├── utils/
│   │   └── helpers.js           # Utility functions
│   └── server.js                # Main server file
├── uploads/                     # File uploads directory
├── .env                         # Environment variables
├── .env.example                 # Example env file
├── .gitignore                   # Git ignore rules
├── package.json                 # Dependencies
└── README.md                    # This file
```

---

## 🔌 API Endpoints

### Base URL
```
http://localhost:3000/api
```

### Authentication

#### 1. Send OTP
```http
POST /api/auth/send-otp
Content-Type: application/json

{
  "email": "student@example.com",
  "rollNumber": "21A01A0501"
}
```

**Response:**
```json
{
  "success": true,
  "message": "OTP sent successfully to your email",
  "expiresIn": 5
}
```

#### 2. Verify OTP & Login
```http
POST /api/auth/verify-otp
Content-Type: application/json

{
  "email": "student@example.com",
  "rollNumber": "21A01A0501",
  "otp": "123456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "rollNumber": "21A01A0501",
    "email": "student@example.com",
    "role": "student"
  }
}
```

#### 3. Get Current User
```http
GET /api/auth/me
Authorization: Bearer <token>
```

#### 4. Update Profile
```http
PUT /api/auth/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "John Doe",
  "department": "Computer Science",
  "year": "3rd Year"
}
```

---

### Grievances

#### 1. Create Grievance
```http
POST /api/grievances
Authorization: Bearer <token>
Content-Type: multipart/form-data

title: Library AC not working
description: The AC in the library has been broken for 3 days...
category: Infrastructure
isAnonymous: false
isEmergency: false
priority: medium
attachments: [file1.jpg, file2.pdf]
```

**Response:**
```json
{
  "success": true,
  "message": "Grievance submitted successfully",
  "grievance": {
    "_id": "507f1f77bcf86cd799439011",
    "title": "Library AC not working",
    "status": "pending",
    "priority": "medium",
    "createdAt": "2024-02-10T10:30:00.000Z"
  }
}
```

#### 2. Get My Grievances
```http
GET /api/grievances/my?status=pending&page=1&limit=20
Authorization: Bearer <token>
```

**Query Parameters:**
- `status` (optional): pending, under_review, in_progress, resolved, rejected
- `category` (optional): Category name
- `priority` (optional): low, medium, high, urgent
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)

#### 3. Get Single Grievance
```http
GET /api/grievances/:id
Authorization: Bearer <token>
```

#### 4. Get Grievance by Anonymous ID
```http
GET /api/grievances/anonymous/:anonymousId
```

#### 5. Get Grievance Statistics
```http
GET /api/grievances/stats
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "stats": {
    "total": 15,
    "pending": 5,
    "under_review": 3,
    "in_progress": 4,
    "resolved": 3,
    "rejected": 0
  }
}
```

---

### Admin/Committee Endpoints

#### 1. Get All Grievances (Committee/Admin)
```http
GET /api/grievances?status=pending&page=1
Authorization: Bearer <token>
```

#### 2. Update Grievance Status (Committee/Admin)
```http
PUT /api/grievances/:id/status
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "in_progress",
  "message": "We are working on fixing the AC"
}
```

#### 3. Add Update/Comment (Committee/Admin)
```http
POST /api/grievances/:id/updates
Authorization: Bearer <token>
Content-Type: application/json

{
  "message": "AC repair scheduled for tomorrow"
}
```

#### 4. Assign Grievance (Admin Only)
```http
PUT /api/grievances/:id/assign
Authorization: Bearer <token>
Content-Type: application/json

{
  "assignedTo": "507f1f77bcf86cd799439012"
}
```

---

## 🔐 Authentication

All protected endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

The token is returned after successful OTP verification and is valid for 7 days (configurable).

---

## 👥 User Roles

### Student (Default)
- Create grievances
- View own grievances
- Track status
- Submit anonymously

### Committee
- View assigned grievances
- Update grievance status
- Add comments/updates

### Admin
- View all grievances
- Assign to committee members
- All committee permissions

---

## 📧 Email Configuration

### Gmail Setup

1. **Enable 2-Factor Authentication** in your Google Account

2. **Generate App Password:**
   - Go to Google Account → Security
   - Select "App passwords"
   - Generate password for "Mail"

3. **Update .env:**
   ```env
   EMAIL_SERVICE=gmail
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASSWORD=your-16-digit-app-password
   ```

### Other Email Services

Update `.env` with your SMTP settings:
```env
EMAIL_SERVICE=smtp
EMAIL_HOST=smtp.example.com
EMAIL_PORT=587
EMAIL_USER=your-email@example.com
EMAIL_PASSWORD=your-password
```

---

## 💾 Database Setup

### Local MongoDB

1. **Install MongoDB:**
   - Download from [mongodb.com](https://www.mongodb.com/try/download/community)
   - Install and start MongoDB service

2. **Update .env:**
   ```env
   MONGODB_URI=mongodb://localhost:27017/risevoice
   ```

### MongoDB Atlas (Cloud)

1. **Create Account:**
   - Go to [mongodb.com/atlas](https://www.mongodb.com/atlas)
   - Create free cluster

2. **Get Connection String:**
   - Click "Connect" → "Connect your application"
   - Copy connection string

3. **Update .env:**
   ```env
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/risevoice
   ```

---

## 📤 File Uploads

### Supported File Types
- Images: JPEG, JPG, PNG
- Documents: PDF
- Audio: MP3, WAV, M4A

### File Size Limit
- Maximum: 10MB per file
- Maximum files per grievance: 5

### Storage
- Files are stored in `uploads/` directory
- Accessible via: `http://localhost:3000/uploads/filename`

---

## 🔒 Security Features

### Implemented
- ✅ JWT authentication
- ✅ Password-less OTP login
- ✅ Rate limiting (100 requests per 15 minutes)
- ✅ Helmet.js security headers
- ✅ CORS configuration
- ✅ Input validation
- ✅ File type validation
- ✅ Role-based access control

### Best Practices
- Change JWT_SECRET in production
- Use HTTPS in production
- Enable MongoDB authentication
- Regular security audits
- Keep dependencies updated

---

## 🧪 Testing

### Manual Testing with Postman

1. **Import Collection:**
   - Create new collection in Postman
   - Add requests from API documentation

2. **Set Environment Variables:**
   ```
   base_url: http://localhost:3000/api
   token: <your-jwt-token>
   ```

3. **Test Flow:**
   - Send OTP → Verify OTP → Get token
   - Use token for protected endpoints

---

## 🚀 Deployment

### Environment Variables for Production

```env
NODE_ENV=production
PORT=3000
MONGODB_URI=<your-production-mongodb-uri>
JWT_SECRET=<strong-random-secret>
ALLOWED_ORIGINS=https://yourdomain.com
```

### Deploy to Heroku

```bash
# Install Heroku CLI
heroku login

# Create app
heroku create risevoice-api

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set MONGODB_URI=<your-uri>
heroku config:set JWT_SECRET=<your-secret>

# Deploy
git push heroku main
```

### Deploy to Railway/Render

1. Connect GitHub repository
2. Set environment variables
3. Deploy automatically

---

## 📊 Monitoring

### Logs

```bash
# View logs in development
npm run dev

# View logs in production
pm2 logs
```

### Health Check

```http
GET /health
```

**Response:**
```json
{
  "success": true,
  "message": "RiseVoice API is running",
  "timestamp": "2024-02-10T10:30:00.000Z",
  "environment": "development"
}
```

---

## 🐛 Troubleshooting

### MongoDB Connection Error
```
Error: connect ECONNREFUSED 127.0.0.1:27017
```
**Solution:** Start MongoDB service

### Email Not Sending
```
Error: Invalid login
```
**Solution:** Check email credentials and app password

### File Upload Error
```
Error: File size too large
```
**Solution:** Check MAX_FILE_SIZE in .env

---

## 📝 License

MIT License - Kakatiya Degree College (Autonomous)

---

## 🤝 Support

For issues or questions:
- Email: support@risevoice.edu.in
- GitHub Issues: [Create Issue]

---

**Built with ❤️ for student welfare**
