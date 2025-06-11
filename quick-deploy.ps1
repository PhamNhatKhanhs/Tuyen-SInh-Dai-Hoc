# 🚀 QUICK DEPLOY TO VERCEL
# Script tự động deploy toàn bộ dự án lên Vercel

param(
    [switch]$Setup,      # Chỉ setup environment variables
    [switch]$Deploy,     # Chỉ deploy
    [switch]$Test        # Test sau khi deploy
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 University Admission System - Vercel Deploy" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Function to check if command exists
function Test-Command {
    param($Command)
    try {
        Get-Command $Command -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Check requirements
Write-Host "`n🔍 Checking requirements..." -ForegroundColor Yellow

if (-not (Test-Command "node")) {
    Write-Host "❌ Node.js not found. Please install Node.js 18+ from https://nodejs.org" -ForegroundColor Red
    exit 1
}

if (-not (Test-Command "npm")) {
    Write-Host "❌ npm not found. Please install Node.js 18+ from https://nodejs.org" -ForegroundColor Red
    exit 1
}

if (-not (Test-Command "vercel")) {
    Write-Host "❌ Vercel CLI not found. Installing..." -ForegroundColor Yellow
    npm install -g vercel
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install Vercel CLI" -ForegroundColor Red
        exit 1
    }
}

$nodeVersion = node --version
$npmVersion = npm --version
$vercelVersion = vercel --version

Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
Write-Host "✅ npm: $npmVersion" -ForegroundColor Green
Write-Host "✅ Vercel CLI: $vercelVersion" -ForegroundColor Green

# If only setup requested
if ($Setup) {
    Write-Host "`n🔧 Setting up environment variables..." -ForegroundColor Yellow
    .\setup-env-vars.ps1
    exit 0
}

# Install dependencies
if (-not $Deploy -and -not $Test) {
    Write-Host "`n📦 Installing dependencies..." -ForegroundColor Yellow
    
    # Backend dependencies
    Write-Host "Installing backend dependencies..." -ForegroundColor Cyan
    Set-Location "backend-app"
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install backend dependencies" -ForegroundColor Red
        exit 1
    }
    Set-Location ".."
    
    # Frontend dependencies
    Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
    Set-Location "frontend-app"
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install frontend dependencies" -ForegroundColor Red
        exit 1
    }
    Set-Location ".."
    
    Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
}

# Build frontend
if (-not $Deploy -and -not $Test) {
    Write-Host "`n🔨 Building frontend..." -ForegroundColor Yellow
    Set-Location "frontend-app"
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Frontend build failed" -ForegroundColor Red
        exit 1
    }
    Set-Location ".."
    Write-Host "✅ Frontend built successfully" -ForegroundColor Green
}

# Deploy to Vercel
if (-not $Test) {
    Write-Host "`n🌍 Deploying to Vercel..." -ForegroundColor Yellow
    
    # Check if user is logged in
    try {
        $whoami = vercel whoami 2>$null
        Write-Host "✅ Logged in as: $whoami" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Not logged in to Vercel. Please login..." -ForegroundColor Yellow
        vercel login
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Vercel login failed" -ForegroundColor Red
            exit 1
        }
    }
    
    # Deploy to production
    Write-Host "Deploying to production..." -ForegroundColor Cyan
    vercel --prod
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Deployment failed" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ Deployment successful!" -ForegroundColor Green
}

# Test deployment
if ($Test -or (-not $Setup -and -not $Deploy)) {
    Write-Host "`n🧪 Testing deployment..." -ForegroundColor Yellow
    
    # Get deployment URL
    try {
        $deploymentInfo = vercel ls --json | ConvertFrom-Json
        $latestDeployment = $deploymentInfo | Where-Object { $_.state -eq "READY" } | Select-Object -First 1
        
        if ($latestDeployment) {
            $deploymentUrl = "https://$($latestDeployment.url)"
            Write-Host "🌐 Testing deployment at: $deploymentUrl" -ForegroundColor Cyan
            
            # Run deployment tests
            .\test-deployment.ps1 -BaseUrl $deploymentUrl
        } else {
            Write-Host "⚠️  No ready deployment found. Please check Vercel dashboard." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "⚠️  Could not retrieve deployment URL. Testing with manual URL..." -ForegroundColor Yellow
        $manualUrl = Read-Host "Enter your Vercel deployment URL"
        if ($manualUrl) {
            .\test-deployment.ps1 -BaseUrl $manualUrl
        }
    }
}

Write-Host "`n🎉 Deployment process completed!" -ForegroundColor Green
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Check your Vercel dashboard: https://vercel.com/dashboard" -ForegroundColor White
Write-Host "2. Test the application thoroughly" -ForegroundColor White
Write-Host "3. Configure environment variables if needed" -ForegroundColor White
Write-Host "4. Set up MongoDB Atlas if not done already" -ForegroundColor White
Write-Host "5. Configure email service (Gmail App Password)" -ForegroundColor White

Write-Host "`n📚 Useful commands:" -ForegroundColor Cyan
Write-Host "- vercel logs: View deployment logs" -ForegroundColor White
Write-Host "- vercel env ls: List environment variables" -ForegroundColor White
Write-Host "- vercel --prod: Redeploy to production" -ForegroundColor White

Write-Host "`n🆘 Need help? Check DEPLOY_GUIDE.md for detailed instructions" -ForegroundColor Yellow

# Bước 5: Deploy
Write-Host "🚀 BƯỚC 5: Deploy lên Vercel..." -ForegroundColor Yellow
Write-Host "📋 Lưu ý: Làm theo hướng dẫn của Vercel CLI" -ForegroundColor Cyan
Write-Host ""

& ".\deploy-prepare.ps1" -Deploy

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "🎉 DEPLOY THÀNH CÔNG!" -ForegroundColor Green
    Write-Host "=" * 60 -ForegroundColor Gray
    Write-Host ""
    Write-Host "📋 CÁC BƯỚC TIẾP THEO:" -ForegroundColor Cyan
    Write-Host "1. 🌐 Vào Vercel Dashboard: https://vercel.com/dashboard" -ForegroundColor White
    Write-Host "2. ⚙️  Thiết lập Environment Variables:" -ForegroundColor White
    Write-Host "   - MONGODB_URI" -ForegroundColor Gray
    Write-Host "   - JWT_SECRET" -ForegroundColor Gray
    Write-Host "   - EMAIL_HOST, EMAIL_PORT, EMAIL_USER, EMAIL_PASS" -ForegroundColor Gray
    Write-Host "   - FRONTEND_URL (URL của app sau khi deploy)" -ForegroundColor Gray
    Write-Host "3. 🚀 Chạy deploy production:" -ForegroundColor White
    Write-Host "   vercel --prod" -ForegroundColor Gray
    Write-Host "4. 🧪 Test ứng dụng trên URL được cung cấp" -ForegroundColor White
    Write-Host ""
    Write-Host "📖 Đọc DEPLOY_GUIDE.md để biết hướng dẫn chi tiết!" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "❌ DEPLOY THẤT BẠI!" -ForegroundColor Red
    Write-Host "📖 Kiểm tra lỗi và đọc DEPLOY_GUIDE.md" -ForegroundColor Yellow
    exit 1
}
