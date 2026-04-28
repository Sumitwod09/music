# OneD App

A lightweight, offline-first music streaming and wallpaper discovery app built with Flutter.

## Features

### Music Tab
- 🎵 Stream music from Cloudflare R2
- 💾 Save songs for offline playback
- 🎨 Beautiful music player UI with album art
- 📱 Responsive design for all screen sizes
- 🔍 Search functionality for songs, artists, and albums

### Wallpaper Tab
- 🖼️ Staggered grid layout for wallpapers
- 📥 Download wallpapers to device gallery
- 🔍 Full-screen preview with zoom
- 🔄 Pull-to-refresh functionality
- 📱 Adaptive grid columns (2-4 based on screen size)

## Technical Specifications

- **Framework**: Flutter 3.0+
- **State Management**: BLoC pattern
- **Architecture**: Clean Architecture with Repository pattern
- **Target Size**: <100MB APK/IPA
- **Offline-First**: Local caching for songs and wallpapers
- **Performance**: <500ms playback latency, <2s manifest load

## Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK compatible with Flutter version
- Android Studio / VS Code with Flutter extensions
- Firebase account (for analytics)

### Installation

1. Clone this repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate JSON serialization files:
   ```bash
   flutter packages pub run build_runner build
   ```

4. Add required assets:
   - Download Roboto fonts to `assets/fonts/`
   - Add app icons to `assets/images/`

5. Configure Firebase:
   - Create a Firebase project
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Enable Firebase Analytics

6. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── themes/
│   ├── utils/
│   └── router/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── presentation/
│   ├── pages/
│   ├── widgets/
│   └── blocs/
└── main.dart
```

## Configuration

### Cloudflare R2 Setup
1. Create an R2 bucket
2. Upload compressed audio files (500-600MB total)
3. Create `songs_metadata.json` manifest at bucket root
4. Update the manifest URL in `music_repository.dart`

### Pinterest API (Optional)
1. Create Pinterest Developer account
2. Generate API keys
3. Update API configuration in `wallpaper_repository.dart`

## Performance Targets

| Metric | Target | Current Status |
|--------|--------|----------------|
| App Size | <100MB | ~30MB (without assets) |
| Manifest Load | <2s | ✅ |
| Playback Latency | <500ms | ✅ |
| DAU Retention | >40% | 📊 To be measured |
| Offline Downloads | >25% | 📊 To be measured |

## Design System

### Colors
- **Primary**: Stormy Teal (#037171)
- **Background**: Midnight Navy (#181D33)
- **Accent**: Strong Cyan (#02C3BD)
- **Error**: 1D Red (#E94C45)

### Typography
- **Font**: Roboto (Google Fonts)
- **Headings**: Bold (700 weight)
- **Body**: Regular (400 weight)
- **Buttons**: Semi-bold (600 weight)

### Components
- **Touch Targets**: Minimum 48dp
- **Corner Radius**: 12dp (cards), 24dp (FABs)
- **Spacing**: 8dp base unit, 16dp major sections

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the implementation plan

---

**OneD** - Music streaming made simple and beautiful.
