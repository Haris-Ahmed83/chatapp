Write-Host "=== Chato Setup Script ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 1: Installing dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "Step 2: Running code generation (Hive adapters, if needed)..." -ForegroundColor Yellow
dart run build_runner build --delete-conflicting-outputs

Write-Host ""
Write-Host "Step 3: Generating localization keys..." -ForegroundColor Yellow
flutter pub run easy_localization:generate -S assets/translations -O lib/src/core/i18n -o locale_keys.g.dart

Write-Host ""
Write-Host "Step 4: Building for web..." -ForegroundColor Yellow
flutter build web

Write-Host ""
Write-Host "=== IMPORTANT: Setup Required ===" -ForegroundColor Magenta
Write-Host "1. Edit .env file with your Supabase credentials (already done)"
Write-Host "2. For iOS: cd ios && pod install && cd .."
Write-Host "3. For web: The web/ directory is already set up"
Write-Host "4. Flutter SDK is installed at: $env:USERPROFILE\flutter\flutter"
Write-Host ""

Write-Host "Run the app:" -ForegroundColor Green
Write-Host "  flutter run           (auto-selects device)"
Write-Host "  flutter run -d chrome (web)"
Write-Host "  flutter run -d windows (desktop)"
Write-Host ""
Write-Host "View web build: open build/web/index.html in a browser" -ForegroundColor Green
