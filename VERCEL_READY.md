# Vercel Deployment Ready

Dự án này đã được cấu hình sẵn sàng để deploy lên Vercel.

## Các file quan trọng đã có:
- ✅ vercel.json (cấu hình deployment)
- ✅ package.json (scripts)
- ✅ .env.example (template)
- ✅ CORS config (backend)

## Deploy ngay:

### Cách 1: Vercel Web (Khuyên dùng)
1. Vào https://vercel.com/new
2. Import Git Repository hoặc upload folder này
3. Vercel sẽ tự động deploy

### Cách 2: GitHub + Vercel
1. Push code lên GitHub
2. Connect với Vercel
3. Auto deploy mọi khi push

## Environment Variables cần thiết:
```
MONGODB_URI=mongodb+srv://...
JWT_SECRET=32-char-random-string
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=gmail-app-password
FRONTEND_URL=https://your-app.vercel.app
NODE_ENV=production
```

Dự án sẽ được deploy tại: https://your-project-name.vercel.app
