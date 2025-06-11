# 🚀 QUICK START - DEPLOY LÊN VERCEL

## ⚡ Deploy nhanh trong 5 phút

### 1. Chạy script tự động
```powershell
.\quick-deploy.ps1
```

### 2. Thiết lập Environment Variables trên Vercel
1. Vào [Vercel Dashboard](https://vercel.com/dashboard)
2. Chọn project → Settings → Environment Variables
3. Thêm các biến sau:

```
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/database
JWT_SECRET=your-32-character-secret-key-here
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-gmail-app-password
EMAIL_FROM="Tuyển Sinh ĐH" <your-email@gmail.com>
FRONTEND_URL=https://your-app.vercel.app
NODE_ENV=production
```

### 3. Deploy production
```powershell
vercel --prod
```

## 🔧 Scripts hữu ích

### Deploy từng bước
```powershell
# Chỉ setup environment variables
.\quick-deploy.ps1 -Setup

# Chỉ deploy
.\quick-deploy.ps1 -Deploy

# Chỉ test
.\quick-deploy.ps1 -Test
```

### Kiểm tra yêu cầu hệ thống
```powershell
.\check-requirements.ps1
```

### Test deployment
```powershell
.\test-deployment.ps1 -BaseUrl "https://your-app.vercel.app"
```

## 📋 Checklist

- [ ] Node.js 18+ đã cài đặt
- [ ] Vercel CLI đã cài đặt (`npm install -g vercel`)
- [ ] MongoDB Atlas cluster đã setup
- [ ] Gmail App Password đã tạo
- [ ] Environment variables đã thiết lập trên Vercel
- [ ] Deploy thành công với `vercel --prod`
- [ ] Test ứng dụng hoạt động

## 🆘 Cần trợ giúp?

- 📖 Đọc [DEPLOY_GUIDE.md](./DEPLOY_GUIDE.md) cho hướng dẫn chi tiết
- 🌐 Kiểm tra [Vercel Dashboard](https://vercel.com/dashboard)
- 📧 Kiểm tra logs với `vercel logs`

## 🎯 Các bước quan trọng

### MongoDB Atlas
1. Tạo cluster miễn phí
2. Tạo database user
3. Whitelist IP (0.0.0.0/0)
4. Lấy connection string

### Gmail App Password
1. Bật 2-Factor Authentication
2. Tạo App Password
3. Sử dụng App Password thay vì password thường

### Vercel Environment Variables
- Phải set tất cả variables trong bảng trên
- Check từng variable một cách cẩn thận
- Deploy lại sau khi set variables

**🎉 Chúc bạn deploy thành công!**
