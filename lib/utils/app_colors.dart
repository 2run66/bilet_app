import 'package:flutter/material.dart';

// ============================================================================
// COLOR PALETTES - Switch between different themes easily
// ============================================================================

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // CURRENT ACTIVE PALETTE: 1 - Vibrant & Energetic
  // Switch by changing the active palette below:
  static const _activePalette = 1; // 1, 2, or 3

  // ----------------------------------------------------------------------------
  // PALETTE 1: Vibrant & Energetic (For Music, Festivals, Entertainment)
  // ----------------------------------------------------------------------------
  static const _palette1Primary = Color(0xFF2563EB); // Electric Blue
  static const _palette1Accent1 = Color(0xFF8B5CF6); // Neon Purple
  static const _palette1Accent2 = Color(0xFFEC4899); // Hot Pink
  static const _palette1Background = Color(0xFF0F172A); // Midnight Gray
  static const _palette1Surface = Color(0xFF1E293B); // Dark Charcoal
  static const _palette1Success = Color(0xFFA3E635); // Bright Lime

  // ----------------------------------------------------------------------------
  // PALETTE 2: Premium & Elegant (For Theatre, Conferences, VIP Events)
  // ----------------------------------------------------------------------------
  static const _palette2Primary = Color(0xFF4F46E5); // Deep Indigo
  static const _palette2Accent1 = Color(0xFFFBBF24); // Gold
  static const _palette2Accent2 = Color(0xFF9A3412); // Soft Burgundy
  static const _palette2Background = Color(0xFFF5F5F4); // Off-White
  static const _palette2Surface = Color(0xFFE7E5E4); // Pearl Gray
  static const _palette2TextPrimary = Color(0xFF0B0B0C); // Rich Black

  // ----------------------------------------------------------------------------
  // PALETTE 3: Minimal & Friendly (For General Events & Community)
  // ----------------------------------------------------------------------------
  static const _palette3Primary = Color(0xFF14B8A6); // Fresh Teal
  static const _palette3Secondary = Color(0xFFFB7185); // Coral
  static const _palette3Accent = Color(0xFF0EA5E9); // Sky Blue
  static const _palette3Background = Color(0xFFF3F4F6); // Light Gray
  static const _palette3Surface = Color(0xFFFFFFFF); // White

  // ============================================================================
  // ACTIVE COLORS - These change based on selected palette
  // ============================================================================

  // Primary Colors
  static Color get primary {
    switch (_activePalette) {
      case 1:
        return _palette1Primary;
      case 2:
        return _palette2Primary;
      case 3:
        return _palette3Primary;
      default:
        return _palette1Primary;
    }
  }

  static Color get primaryLight {
    switch (_activePalette) {
      case 1:
        return const Color(0xFF3B82F6);
      case 2:
        return const Color(0xFF6366F1);
      case 3:
        return const Color(0xFF2DD4BF);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  static Color get primaryDark {
    switch (_activePalette) {
      case 1:
        return const Color(0xFF1E40AF);
      case 2:
        return const Color(0xFF4338CA);
      case 3:
        return const Color(0xFF0D9488);
      default:
        return const Color(0xFF1E40AF);
    }
  }

  // Secondary/Accent Colors
  static Color get secondary {
    switch (_activePalette) {
      case 1:
        return _palette1Accent1; // Neon Purple
      case 2:
        return _palette2Accent1; // Gold
      case 3:
        return _palette3Secondary; // Coral
      default:
        return _palette1Accent1;
    }
  }

  static Color get accent {
    switch (_activePalette) {
      case 1:
        return _palette1Accent2; // Hot Pink
      case 2:
        return _palette2Accent2; // Burgundy
      case 3:
        return _palette3Accent; // Sky Blue
      default:
        return _palette1Accent2;
    }
  }

  // Background Colors
  static Color get background {
    switch (_activePalette) {
      case 1:
        return _palette1Background;
      case 2:
        return _palette2Background;
      case 3:
        return _palette3Background;
      default:
        return _palette1Background;
    }
  }

  static Color get surface {
    switch (_activePalette) {
      case 1:
        return _palette1Surface;
      case 2:
        return _palette2Surface;
      case 3:
        return _palette3Surface;
      default:
        return _palette1Surface;
    }
  }

  static Color get surfaceVariant {
    switch (_activePalette) {
      case 1:
        return const Color(0xFF334155);
      case 2:
        return const Color(0xFFD6D3D1);
      case 3:
        return const Color(0xFFE5E7EB);
      default:
        return const Color(0xFF334155);
    }
  }

  // Text Colors
  static Color get textPrimary {
    switch (_activePalette) {
      case 1:
        return const Color(0xFFF8FAFC); // Light text for dark theme
      case 2:
        return _palette2TextPrimary;
      case 3:
        return const Color(0xFF111827);
      default:
        return const Color(0xFFF8FAFC);
    }
  }

  static Color get textSecondary {
    switch (_activePalette) {
      case 1:
        return const Color(0xFFCBD5E1);
      case 2:
        return const Color(0xFF57534E);
      case 3:
        return const Color(0xFF4B5563);
      default:
        return const Color(0xFFCBD5E1);
    }
  }

  static Color get textTertiary {
    switch (_activePalette) {
      case 1:
        return const Color(0xFF94A3B8);
      case 2:
        return const Color(0xFF78716C);
      case 3:
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  static Color get textOnPrimary {
    return const Color(0xFFFFFFFF);
  }

  // Status Colors
  static Color get success {
    switch (_activePalette) {
      case 1:
        return _palette1Success; // Bright Lime
      case 2:
        return const Color(0xFF16A34A); // Green
      case 3:
        return const Color(0xFF10B981); // Emerald
      default:
        return _palette1Success;
    }
  }

  static const Color error = Color(0xFFEF4444); // Red for all palettes
  static const Color warning = Color(0xFFF59E0B); // Amber for all palettes

  static Color get info {
    switch (_activePalette) {
      case 1:
        return _palette1Primary;
      case 2:
        return const Color(0xFF3B82F6);
      case 3:
        return _palette3Accent;
      default:
        return _palette1Primary;
    }
  }

  // UI Element Colors
  static Color get divider {
    switch (_activePalette) {
      case 1:
        return const Color(0xFF475569);
      case 2:
        return const Color(0xFFD4D4D4);
      case 3:
        return const Color(0xFFD1D5DB);
      default:
        return const Color(0xFF475569);
    }
  }

  static Color get border {
    switch (_activePalette) {
      case 1:
        return const Color(0xFF475569);
      case 2:
        return const Color(0xFFD4D4D4);
      case 3:
        return const Color(0xFFD1D5DB);
      default:
        return const Color(0xFF475569);
    }
  }

  static const Color shadow = Color(0x33000000);
  static const Color overlay = Color(0x66000000);

  // Ticket Specific Colors
  static Color get ticketActive => success;
  static const Color ticketUsed = Color(0xFF6B7280); // Gray for all
  static const Color ticketExpired = error;
  static Color get ticketPending => warning;

  // Input Field Colors
  static Color get inputFill {
    switch (_activePalette) {
      case 1:
        return const Color(0xFF334155);
      case 2:
        return const Color(0xFFFAFAF9);
      case 3:
        return const Color(0xFFFFFFFF);
      default:
        return const Color(0xFF334155);
    }
  }

  static Color get inputBorder => border;
  static Color get inputFocused => primary;
  static const Color inputError = error;

  // Button Colors
  static Color get buttonPrimary => primary;
  static Color get buttonSecondary => secondary;

  static Color get buttonDisabled {
    switch (_activePalette) {
      case 1:
        return const Color(0xFF475569);
      case 2:
        return const Color(0xFFA8A29E);
      case 3:
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFF475569);
    }
  }

  static const Color buttonTextPrimary = Color(0xFFFFFFFF);

  static Color get buttonTextSecondary => textPrimary;

  // Card Colors
  static Color get cardBackground => surface;
  static const Color cardShadow = Color(0x1A000000);

  // Gradient Colors
  static LinearGradient get primaryGradient {
    switch (_activePalette) {
      case 1:
        return LinearGradient(
          colors: [_palette1Primary, const Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return LinearGradient(
          colors: [_palette2Primary, const Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return LinearGradient(
          colors: [_palette3Primary, const Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [_palette1Primary, const Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  static LinearGradient get ticketGradient {
    switch (_activePalette) {
      case 1:
        return LinearGradient(
          colors: [_palette1Primary, _palette1Accent1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return LinearGradient(
          colors: [_palette2Primary, _palette2Accent1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return LinearGradient(
          colors: [_palette3Primary, _palette3Accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [_palette1Primary, _palette1Accent1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  static LinearGradient get accentGradient {
    switch (_activePalette) {
      case 1:
        return LinearGradient(
          colors: [_palette1Accent1, _palette1Accent2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return LinearGradient(
          colors: [_palette2Accent1, _palette2Accent2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return LinearGradient(
          colors: [_palette3Secondary, _palette3Accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [_palette1Accent1, _palette1Accent2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  // Dark Mode Colors (for future implementation)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);

  // Helper method to get palette name
  static String getPaletteName() {
    switch (_activePalette) {
      case 1:
        return 'Vibrant & Energetic';
      case 2:
        return 'Premium & Elegant';
      case 3:
        return 'Minimal & Friendly';
      default:
        return 'Unknown';
    }
  }
}
