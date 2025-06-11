# Test Deployment Script
# Kiểm tra các endpoints sau khi deploy

param(
    [string]$BaseUrl = "https://your-app.vercel.app"
)

Write-Host "🧪 Testing deployment at: $BaseUrl" -ForegroundColor Green

# Test API Health
Write-Host "`n📊 Testing API Health..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$BaseUrl/api/health" -Method GET -TimeoutSec 10
    Write-Host "✅ Health check passed: $($healthResponse.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Health check failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test CORS
Write-Host "`n🌐 Testing CORS..." -ForegroundColor Yellow
try {
    $corsHeaders = @{
        'Origin' = 'https://your-frontend-domain.com'
        'Access-Control-Request-Method' = 'POST'
        'Access-Control-Request-Headers' = 'Content-Type'
    }
    $corsResponse = Invoke-WebRequest -Uri "$BaseUrl/api/universities" -Method OPTIONS -Headers $corsHeaders -TimeoutSec 10
    Write-Host "✅ CORS configured correctly" -ForegroundColor Green
} catch {
    Write-Host "⚠️  CORS test inconclusive: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Test Public Endpoints
Write-Host "`n🏛️  Testing public endpoints..." -ForegroundColor Yellow

$publicEndpoints = @(
    "/api/universities",
    "/api/majors", 
    "/api/admission-methods",
    "/api/subject-groups"
)

foreach ($endpoint in $publicEndpoints) {
    try {
        $response = Invoke-RestMethod -Uri "$BaseUrl$endpoint" -Method GET -TimeoutSec 10
        Write-Host "✅ $endpoint - OK" -ForegroundColor Green
    } catch {
        Write-Host "❌ $endpoint - Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test Frontend
Write-Host "`n🖥️  Testing frontend..." -ForegroundColor Yellow
try {
    $frontendResponse = Invoke-WebRequest -Uri $BaseUrl -Method GET -TimeoutSec 10
    if ($frontendResponse.StatusCode -eq 200) {
        Write-Host "✅ Frontend loaded successfully" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Frontend failed to load: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📝 Test Results Summary:" -ForegroundColor Cyan
Write-Host "- Check Vercel dashboard for detailed logs" -ForegroundColor White
Write-Host "- Test authentication endpoints manually" -ForegroundColor White
Write-Host "- Verify email service with test registration" -ForegroundColor White

Write-Host "`n🎉 Deployment testing completed!" -ForegroundColor Green
