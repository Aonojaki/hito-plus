import 'package:flutter/material.dart';

class AppTheme {
  static const Color ink = Color(0xFF000000);
  static const Color paper = Color(0xFFFFFFFF);
  static const Color panel = Color(0xFFF2F2F2);
  static const Color muted = Color(0xFF808080);

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;

  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );

  static ThemeData get theme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: paper,
      colorScheme: const ColorScheme.light(
        primary: ink,
        onPrimary: paper,
        surface: paper,
        onSurface: ink,
        secondary: ink,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
        fontFamily: 'Segoe UI',
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: paper,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: BorderSide(color: ink, width: 1.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: BorderSide(color: ink, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadiusMd,
          borderSide: BorderSide(color: ink, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          foregroundColor: ink,
          backgroundColor: panel,
          shape: const RoundedRectangleBorder(
            borderRadius: borderRadiusMd,
            side: BorderSide(color: ink, width: 1.8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: const BorderSide(color: ink, width: 1.8),
          shape: const RoundedRectangleBorder(borderRadius: borderRadiusMd),
        ),
      ),
      cardTheme: const CardThemeData(
        color: paper,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusMd,
          side: BorderSide(color: ink, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(color: ink, thickness: 1),
      tooltipTheme: const TooltipThemeData(
        decoration: BoxDecoration(
          color: paper,
          borderRadius: borderRadiusSm,
          border: Border.fromBorderSide(BorderSide(color: ink, width: 1.4)),
        ),
        textStyle: TextStyle(color: ink, fontFamily: 'Consolas'),
      ),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: paper,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLg,
          side: BorderSide(color: ink, width: 2),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: paper,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLg,
          side: BorderSide(color: ink, width: 2),
        ),
      ),
    );
  }
}
