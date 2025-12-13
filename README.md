# PS5 UI Replica - Flutter

A Flutter implementation of the PlayStation 5 user interface, replicating the sleek design and smooth animations of the PS5 dashboard.

## Features

- **Intro Screen**: Animated welcome screen with glowing effects and pulsing PS button
- **User Selection**: User profile selection screen
- **Dashboard**: Full PS5-style dashboard with:
  - Games and Media tabs
  - Horizontal game/app carousel
  - Dynamic background images
  - Game details with progress, trophies, and news
  - Featured media section for media apps
  - Smooth animations and transitions

## Prerequisites

- Flutter SDK (3.6.0 or higher)
- Dart SDK (3.6.1 or higher)
- A device or emulator to run the app

## Installation

1. Navigate to the project directory:
   ```bash
   cd /Users/mohamedmelekchtourou/Desktop/ps5_ui_flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

## Running the App

### On Desktop (macOS, Windows, Linux)
```bash
flutter run -d macos
# or
flutter run -d windows
# or
flutter run -d linux
```

### On Mobile (iOS, Android)
```bash
flutter run -d ios
# or
flutter run -d android
```

### On Web
```bash
flutter run -d chrome
```

**Note**: For the best experience, run the app on a device with a landscape orientation or a desktop platform.

## Project Structure

```
lib/
├── main.dart                 # App entry point and navigation logic
├── models/
│   └── game.dart            # Data models (Game, FeaturedMedia, etc.)
├── data/
│   └── games_data.dart      # Static data for games and media
├── screens/
│   ├── intro_screen.dart    # Welcome/intro screen
│   ├── user_select_screen.dart  # User selection screen
│   └── dashboard_screen.dart    # Main dashboard
└── widgets/
    ├── top_bar.dart         # Top navigation bar
    ├── game_row.dart        # Horizontal game carousel
    └── hero_section.dart    # Game details section

assets/
└── images/
    └── portfolio/           # Project portfolio images
```

## Key Dependencies

- `cached_network_image`: For efficient image loading and caching
- `google_fonts`: For custom typography
- `lucide_icons_flutter`: For icons matching the original design

## Customization

### Adding Your Own Games/Media

Edit `lib/data/games_data.dart` to add or modify games and media apps:

```dart
Game(
  id: 'your-game-id',
  type: ContentType.game,
  title: 'Your Game Title',
  icon: 'path/to/icon.png',
  background: 'https://your-background-image-url.jpg',
  description: 'Your game description',
  progress: 50,
  // ... more properties
)
```

### Modifying Colors and Styles

- Colors and theme settings are in `lib/main.dart`
- Individual component styles can be modified in their respective widget files

## Known Limitations

- Some images use network URLs and require internet connectivity
- Local asset images need to be placed in the `assets/images/` directory
- The app is optimized for landscape orientation

## Original Project

This is a Flutter port of the React-based PS5 UI replica. The original project used:
- React + TypeScript
- Vite
- Framer Motion for animations
- Tailwind CSS for styling

## License

This project is for educational purposes only. PlayStation and PS5 are trademarks of Sony Interactive Entertainment.

## Screenshots

The app includes:
- Animated intro screen with glowing particles
- User selection with profile avatars
- Dashboard with dynamic backgrounds
- Game details with progress tracking
- Trophy display system
- News and updates section

Enjoy exploring the PS5 UI in Flutter!
