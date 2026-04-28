import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (from user's color image)
  static const deepBurgundy = Color(0xFF561C24);
  static const wine = Color(0xFF6D2932);
  static const warmBeige = Color(0xFFC7B7A3);
  static const lightCream = Color(0xFFE8D8C4);

  // Derived Dark Backgrounds
  static const darkBg = Color(0xFF1A0E11);
  static const cardBg = Color(0xFF2A1519);
  static const surfaceLight = Color(0xFF3A2028);

  // Semantic Colors
  static const background = darkBg;
  static const surface = cardBg;
  static const primary = deepBurgundy;
  static const secondary = wine;
  static const accent = warmBeige;
  static const textPrimary = lightCream;
  static const textSecondary = warmBeige;
  static const white = Color(0xFFFFFFFF);
  static const error = Color(0xFFCF6679);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [deepBurgundy, wine],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const warmGradient = LinearGradient(
    colors: [Color(0xFF561C24), Color(0xFF3A2028), Color(0xFF1A0E11)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const accentGradient = LinearGradient(
    colors: [warmBeige, lightCream],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
