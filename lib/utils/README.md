# App Utils - Color & Theme Management

This directory contains centralized color and theme management for the Bilet App.

## Files

### `app_colors.dart`
Contains all color constants used throughout the app. This provides a single source of truth for all colors.

### `app_theme.dart`
Contains the complete theme configuration for light and dark modes.

## Usage

### Using Colors in Your Widgets

Import the colors file:

```dart
import 'package:bilet_app/utils/app_colors.dart';
```

Then use the colors:

```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textOnPrimary),
  ),
)
```

### Available Color Categories

#### Primary Colors
- `AppColors.primary` - Main brand color
- `AppColors.primaryLight` - Lighter variant
- `AppColors.primaryDark` - Darker variant

#### Text Colors
- `AppColors.textPrimary` - Main text color
- `AppColors.textSecondary` - Secondary text (gray)
- `AppColors.textTertiary` - Tertiary text (lighter gray)
- `AppColors.textOnPrimary` - Text on primary background (white)

#### Status Colors
- `AppColors.success` - Success messages (green)
- `AppColors.error` - Error messages (red)
- `AppColors.warning` - Warning messages (orange)
- `AppColors.info` - Info messages (blue)

#### Ticket Specific Colors
- `AppColors.ticketActive` - Active tickets (green)
- `AppColors.ticketUsed` - Used tickets (gray)
- `AppColors.ticketExpired` - Expired tickets (red)
- `AppColors.ticketPending` - Pending tickets (orange)

#### Gradients
- `AppColors.primaryGradient` - Primary gradient
- `AppColors.ticketGradient` - Ticket card gradient

### Using Theme

The theme is already configured in `main.dart`. All Material widgets will automatically use the theme colors.

```dart
// These will use theme colors automatically
ElevatedButton(onPressed: () {}, child: Text('Button'))
TextFormField(decoration: InputDecoration(labelText: 'Email'))
```

### Adding New Colors

To add new colors:

1. Open `lib/utils/app_colors.dart`
2. Add your color constant:
```dart
static const Color myNewColor = Color(0xFF123456);
```

3. If needed, update the theme in `lib/utils/app_theme.dart`

### Dark Mode

Dark mode colors are already defined in `app_colors.dart` and a basic dark theme is configured in `app_theme.dart`. To enable dark mode:

```dart
// In main.dart
themeMode: ThemeMode.dark, // or ThemeMode.system for auto
```

## Benefits of This Approach

✅ **Consistency** - All colors defined in one place  
✅ **Maintainability** - Easy to update colors app-wide  
✅ **Readability** - Semantic color names (e.g., `textSecondary` instead of `Colors.grey`)  
✅ **Type Safety** - Compile-time checking of color usage  
✅ **Theme Support** - Built-in light/dark mode support  
✅ **Scalability** - Easy to add new colors as the app grows  

## Example: Creating a Colored Container

```dart
import 'package:flutter/material.dart';
import 'package:bilet_app/utils/app_colors.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Title',
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Subtitle',
              style: TextStyle(
                color: AppColors.textOnPrimary.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

