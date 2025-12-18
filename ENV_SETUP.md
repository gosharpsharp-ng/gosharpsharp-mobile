# Environment Setup Instructions

## Google Maps API Key Configuration

This app uses environment-based configuration to keep API keys secure and out of version control.

### For Development Team

1. **Copy the example env file:**
   ```bash
   cp .env.example .env.dev
   cp .env.example .env.prod
   ```

2. **Add your Google Maps API key to both files:**
   ```
   GOOGLE_MAPS_API_KEY=YOUR_ACTUAL_API_KEY_HERE
   BASE_URL=https://staging.gosharpsharp.com/api/v1
   ```

3. **For iOS builds, add the key to Xcode:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select the `Runner` project
   - Go to `Build Settings`
   - Search for "User-Defined"
   - Add a new setting: `GOOGLE_MAPS_API_KEY` with your API key value

### Build Commands

**Development/Debug build (uses .env.dev):**
```bash
flutter run
flutter build apk --debug
```

**Production/Release build (uses .env.prod):**
```bash
flutter build apk --release --dart-define=BUILD_MODE=prod
flutter build appbundle --release --dart-define=BUILD_MODE=prod
flutter build ios --release --dart-define=BUILD_MODE=prod
```

### Security Notes

- ⚠️ **NEVER** commit `.env.dev` or `.env.prod` files to git
- Only `.env.example` should be in version control
- API keys are loaded from environment variables at runtime
- iOS keys are loaded from Info.plist (configured via Xcode build settings)

### Troubleshooting

**Maps not showing on iOS:**
- Ensure you've added `GOOGLE_MAPS_API_KEY` to Xcode build settings
- Clean and rebuild: `flutter clean && flutter pub get`

**Maps not showing on Android:**
- Check that `android/local.properties` contains `GOOGLE_MAPS_API_KEY`
- This file is auto-generated but you may need to add the key manually

**"Invalid API key" error:**
- Verify the API key has the correct restrictions in Google Cloud Console
- Enable required APIs: Maps SDK for Android, Maps SDK for iOS, Places API
