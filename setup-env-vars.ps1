# Vercel Environment Variables Setup Script
# Automatically add environment variables to Vercel project

param(
    [string]$ProjectName = "tuyen-sinh-dh"
)

Write-Host "🔧 Setting up Vercel environment variables for project: $ProjectName" -ForegroundColor Green

# Check if vercel CLI is installed
try {
    $vercelVersion = vercel --version
    Write-Host "✅ Vercel CLI found: $vercelVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Vercel CLI not found. Please install it first:" -ForegroundColor Red
    Write-Host "npm install -g vercel" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n📝 Setting up environment variables..." -ForegroundColor Yellow

# Environment variables to set
$envVars = @{
    "NODE_ENV" = "production"
    "JWT_SECRET" = ""
    "MONGODB_URI" = ""
    "EMAIL_HOST" = "smtp.gmail.com"
    "EMAIL_PORT" = "587"
    "EMAIL_SECURE" = "false"
    "EMAIL_USER" = ""
    "EMAIL_PASS" = ""
    "EMAIL_FROM" = ""
    "FRONTEND_URL" = ""
    "VITE_API_BASE_URL" = ""
}

Write-Host "`n⚠️  You will need to provide values for the following variables:" -ForegroundColor Yellow
Write-Host "- JWT_SECRET (32+ character random string)" -ForegroundColor White
Write-Host "- MONGODB_URI (MongoDB Atlas connection string)" -ForegroundColor White
Write-Host "- EMAIL_USER (your Gmail address)" -ForegroundColor White
Write-Host "- EMAIL_PASS (Gmail App Password)" -ForegroundColor White
Write-Host "- EMAIL_FROM (formatted email with name)" -ForegroundColor White
Write-Host "- FRONTEND_URL (your Vercel app URL)" -ForegroundColor White
Write-Host "- VITE_API_BASE_URL (your Vercel app URL + /api)" -ForegroundColor White

$continue = Read-Host "`nDo you want to continue? (y/n)"
if ($continue -ne "y" -and $continue -ne "Y") {
    Write-Host "Setup cancelled." -ForegroundColor Yellow
    exit 0
}

# Set each environment variable
foreach ($key in $envVars.Keys) {
    if ($envVars[$key] -eq "") {
        Write-Host "`n🔑 Setting $key..." -ForegroundColor Cyan
        
        # Provide hints for specific variables
        switch ($key) {
            "JWT_SECRET" {
                Write-Host "Hint: Generate with: openssl rand -base64 32" -ForegroundColor DarkGray
            }
            "MONGODB_URI" {
                Write-Host "Hint: mongodb+srv://username:password@cluster.mongodb.net/dbname" -ForegroundColor DarkGray
            }
            "EMAIL_FROM" {
                Write-Host "Hint: `"Tuyển Sinh ĐH`" <your-email@gmail.com>" -ForegroundColor DarkGray
            }
            "FRONTEND_URL" {
                Write-Host "Hint: https://your-app.vercel.app" -ForegroundColor DarkGray
            }
            "VITE_API_BASE_URL" {
                Write-Host "Hint: https://your-app.vercel.app/api" -ForegroundColor DarkGray
            }
        }
        
        try {
            vercel env add $key
            Write-Host "✅ $key added successfully" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to add $key" -ForegroundColor Red
        }
    } else {
        # Variables with default values
        try {
            echo $envVars[$key] | vercel env add $key
            Write-Host "✅ $key set to: $($envVars[$key])" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to set $key" -ForegroundColor Red
        }
    }
}

Write-Host "`n🎉 Environment variables setup completed!" -ForegroundColor Green
Write-Host "📝 You can verify them at: https://vercel.com/dashboard" -ForegroundColor Cyan
Write-Host "🚀 Now run: vercel --prod" -ForegroundColor Yellow
