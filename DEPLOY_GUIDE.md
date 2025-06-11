# 🚀 HƯỚNG DẪN DEPLOY LÊN VERCEL CHI TIẾT

## 📋 Mục lục
1. [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
2. [Chuẩn bị MongoDB Atlas](#chuẩn-bị-mongodb-atlas)
3. [Cấu hình Email Service](#cấu-hình-email-service)
4. [Deploy lên Vercel](#deploy-lên-vercel)
5. [Troubleshooting](#troubleshooting)

---

## 🔧 Yêu cầu hệ thống

### Cài đặt Node.js
1. Tải Node.js từ [nodejs.org](https://nodejs.org/) (phiên bản 18+)
2. Kiểm tra cài đặt:
```powershell
node --version
npm --version
```

### Cài đặt Vercel CLI
```powershell
npm install -g vercel
```

### Cài đặt Git (nếu chưa có)
```powershell
# Tải từ https://git-scm.com/download/win
git --version
```

---

## 🗄️ Chuẩn bị MongoDB Atlas

### 1. Tạo tài khoản MongoDB Atlas
- Truy cập [MongoDB Atlas](https://cloud.mongodb.com)
- Đăng ký tài khoản miễn phí
- Tạo organization và project mới

### 2. Tạo Cluster
- Chọn "Build a Database"
- Chọn "Shared" (miễn phí)
- Chọn provider: AWS, region gần nhất
- Cluster Name: `university-admission-cluster`

### 3. Tạo Database User
- Database Access → Add New Database User
- Authentication Method: Password
- Username: `admin-user`
- Password: Tạo password mạnh (lưu lại)
- Database User Privileges: Read and write to any database

### 4. Whitelist IP
- Network Access → Add IP Address
- Chọn "Allow Access from Anywhere" (0.0.0.0/0)
- Hoặc thêm IP cụ thể

### 5. Lấy Connection String
- Clusters → Connect → Connect your application
- Driver: Node.js, Version: 4.1 or later
- Copy connection string:
```
mongodb+srv://admin-user:<password>@university-admission-cluster.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

---

## 📧 Cấu hình Email Service

### Option 1: Gmail (Khuyên dùng)

#### 1. Bật 2-Factor Authentication
- Google Account → Security → 2-Step Verification → Turn On

#### 2. Tạo App Password
- Google Account → Security → 2-Step Verification → App passwords
- Select app: Mail
- Select device: Other (custom name) → "University Admission System"
- Copy the 16-character password

#### 3. Environment Variables
```env
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_SECURE=false
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-16-char-app-password
EMAIL_FROM="Tuyển Sinh ĐH" <your-email@gmail.com>
```

### Option 2: SendGrid
1. Tạo tài khoản [SendGrid](https://sendgrid.com)
2. Tạo API Key
3. Verify domain/sender
```env
EMAIL_HOST=smtp.sendgrid.net
EMAIL_PORT=587
EMAIL_USER=apikey
```

---

## 🚀 Deploy lên Vercel

### 1. Chuẩn bị dự án

#### Clone hoặc download dự án
```powershell
git clone https://github.com/your-username/tuyen-sinh-dh.git
cd tuyen-sinh-dh
```

#### Kiểm tra yêu cầu hệ thống
```powershell
.\check-requirements.ps1
```

#### Cài đặt dependencies
```powershell
.\deploy-prepare.ps1 -Install
```

### 2. Login Vercel
```powershell
vercel login
```

### 3. Deploy lần đầu
```powershell
vercel
```

Trả lời các câu hỏi:
- Set up and deploy? **Y**
- Which scope? **Your account**
- Link to existing project? **N**
- Project name: **tuyen-sinh-dh**
- In which directory? **./** (root)

### 4. Cấu hình Environment Variables

#### Cách 1: Qua Vercel Dashboard
1. Truy cập [Vercel Dashboard](https://vercel.com/dashboard)
2. Chọn project → Settings → Environment Variables
3. Thêm các biến:

| Variable | Value | Environment |
|----------|--------|-------------|
| `MONGODB_URI` | `mongodb+srv://...` | Production |
| `JWT_SECRET` | `your-32-char-secret-key` | Production |
| `EMAIL_HOST` | `smtp.gmail.com` | Production |
| `EMAIL_PORT` | `587` | Production |
| `EMAIL_SECURE` | `false` | Production |
| `EMAIL_USER` | `your-email@gmail.com` | Production |
| `EMAIL_PASS` | `your-app-password` | Production |
| `EMAIL_FROM` | `"Tuyển Sinh ĐH" <your-email@gmail.com>` | Production |
| `FRONTEND_URL` | `https://your-app.vercel.app` | Production |
| `NODE_ENV` | `production` | Production |
| `VITE_API_BASE_URL` | `https://your-app.vercel.app/api` | Production |

#### Cách 2: Qua CLI
```powershell
vercel env add MONGODB_URI
# Nhập value khi được hỏi

vercel env add JWT_SECRET
# Tạo secret key mạnh: openssl rand -base64 32

# Tiếp tục với các biến khác...
```

### 5. Deploy Production
```powershell
vercel --prod
```

### 6. Kiểm tra Deployment
- Truy cập URL được cung cấp
- Kiểm tra API endpoints: `https://your-app.vercel.app/api/health`
- Test login và register

---

## 🛠️ Scripts Tự động

### Quick Deploy Script
```powershell
# Chạy tất cả trong một lệnh
.\quick-deploy.ps1
```

### Deploy từng bước
```powershell
# Kiểm tra yêu cầu
.\check-requirements.ps1

# Cài đặt dependencies
.\deploy-prepare.ps1 -Install

# Build frontend
.\deploy-prepare.ps1 -Build

# Deploy
vercel --prod
```

---

## 🐛 Troubleshooting

### 1. MongoDB Connection Issues

#### Error: MongoNetworkError
```
MongoNetworkError: failed to connect to server
```

**Solutions:**
1. Kiểm tra IP whitelist trong MongoDB Atlas
2. Kiểm tra connection string có đúng không
3. Kiểm tra password có special characters → URL encode

#### Error: Authentication failed
```
MongoError: Authentication failed
```

**Solutions:**
1. Kiểm tra username/password trong connection string
2. Đảm bảo user có quyền read/write database
3. Kiểm tra database name trong connection string

### 2. Vercel Deployment Issues

#### Error: Build failed
```
Error: Command "npm run build" exited with 1
```

**Solutions:**
1. Kiểm tra lỗi build locally trước:
```powershell
cd frontend-app
npm run build
```
2. Fix lỗi TypeScript/ESLint
3. Kiểm tra environment variables

#### Error: Function timeout
```
Error: Function execution timeout
```

**Solutions:**
1. Tối ưu database queries
2. Thêm database indexes
3. Tăng timeout trong vercel.json:
```json
{
  "functions": {
    "backend-app/src/server.js": {
      "maxDuration": 30
    }
  }
}
```

### 3. Email Service Issues

#### Error: Invalid login
```
Error: Invalid login: 535-5.7.8 Username and Password not accepted
```

**Solutions:**
1. Sử dụng App Password thay vì password thường
2. Bật 2-Factor Authentication
3. Kiểm tra EMAIL_USER và EMAIL_PASS

#### Error: Connection timeout
```
Error: Connection timeout
```

**Solutions:**
1. Thử port khác: 465 (secure) hoặc 587 (TLS)
2. Cập nhật EMAIL_SECURE:
   - Port 465: `EMAIL_SECURE=true`
   - Port 587: `EMAIL_SECURE=false`

### 4. CORS Issues

#### Error: CORS policy
```
Access to fetch blocked by CORS policy
```

**Solutions:**
1. Kiểm tra FRONTEND_URL trong environment variables
2. Cập nhật CORS config trong backend
3. Đảm bảo API base URL đúng trong frontend

### 5. File Upload Issues

#### Error: File too large
```
Error: File too large
```

**Solutions:**
1. Vercel có giới hạn 4.5MB cho serverless functions
2. Sử dụng cloud storage (AWS S3, Cloudinary) cho files lớn
3. Compress images trước khi upload

---

## 📊 Performance Optimization

### 1. Database Optimization
```javascript
// Thêm indexes cho queries thường dùng
db.applications.createIndex({ "candidate": 1, "status": 1 })
db.applications.createIndex({ "university": 1, "year": 1 })
db.users.createIndex({ "email": 1 }, { unique: true })
```

### 2. Frontend Optimization
- Enable gzip compression
- Code splitting với React.lazy()
- Image optimization với next/image equivalent
- Bundle analysis với webpack-bundle-analyzer

### 3. Vercel Edge Functions
Chuyển một số API endpoints sang Edge Functions để giảm latency.

---

## 🔒 Security Checklist

- [ ] JWT secret đủ mạnh (32+ characters)
- [ ] MongoDB connection string không exposed
- [ ] Email credentials secure
- [ ] CORS properly configured
- [ ] Rate limiting enabled
- [ ] Input validation on all endpoints
- [ ] File upload restrictions
- [ ] HTTPS enforced

---

## 📈 Monitoring & Analytics

### 1. Vercel Analytics
Enable trong dashboard để track performance

### 2. Error Monitoring
Tích hợp Sentry hoặc similar service:
```javascript
// Thêm vào backend
const Sentry = require('@sentry/node');
Sentry.init({ dsn: process.env.SENTRY_DSN });
```

### 3. Database Monitoring
Sử dụng MongoDB Atlas monitoring tools

---

## 🎯 Post-Deployment Tasks

### 1. Domain Setup (Optional)
- Mua domain từ Namecheap, GoDaddy, etc.
- Configure DNS trong Vercel dashboard
- Setup SSL certificate (tự động)

### 2. Custom Email Domain
- Setup custom domain cho email
- Configure SPF, DKIM records
- Update EMAIL_FROM environment variable

### 3. Backup Strategy
- MongoDB Atlas automatic backups
- Export/import scripts cho data migration
- Regular database exports

---

## 📞 Support & Resources

### Official Documentation
- [Vercel Documentation](https://vercel.com/docs)
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Node.js Deployment Guide](https://nodejs.org/en/docs/guides/)

### Community
- [Vercel Discord](https://discord.gg/vercel)
- [MongoDB Community](https://community.mongodb.com/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/vercel)

### Monitoring Tools
- [Vercel Analytics](https://vercel.com/analytics)
- [MongoDB Compass](https://www.mongodb.com/products/compass)
- [Postman](https://www.postman.com/) cho API testing

---

**🎉 Chúc mừng! Dự án của bạn đã được deploy thành công lên Vercel!**

Nếu gặp vấn đề, vui lòng tham khảo phần Troubleshooting hoặc tạo issue trên GitHub.
- Đảm bảo IP được whitelist

**4. Email không gửi được**
- Kiểm tra Gmail App Password
- Kiểm tra 2FA đã bật

### Debug commands:
```powershell
# Xem logs real-time
vercel logs --follow

# Test local
vercel dev

# Kiểm tra environment variables
vercel env ls
```

## 📱 Testing sau khi deploy

1. **Frontend**: Truy cập https://your-app.vercel.app
2. **API Health Check**: https://your-app.vercel.app/api/health
3. **Login/Register**: Test tính năng auth
4. **File Upload**: Test upload tài liệu
5. **Email**: Test gửi email notification

## 🎯 Performance Tips

1. **Frontend**:
   - Code splitting đã được áp dụng
   - Lazy loading components
   - Image optimization

2. **Backend**:
   - Database indexing
   - Connection pooling
   - Caching headers

## 📞 Support

Nếu có vấn đề trong quá trình deploy:
1. Kiểm tra Vercel logs
2. Kiểm tra browser console
3. Tham khảo Vercel documentation

---

**🎉 Chúc mừng! Dự án của bạn đã sẵn sàng để deploy lên Vercel!**
