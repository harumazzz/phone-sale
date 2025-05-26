import 'package:flutter/material.dart' as material;
import 'package:google_fonts/google_fonts.dart';

class MaterialDesign {
  static final material.ThemeData lightTheme = material.ThemeData(
    brightness: material.Brightness.light,
    useMaterial3: true,
    colorScheme: material.ColorScheme.fromSeed(seedColor: material.Colors.blue, primary: material.Colors.blue),
    scaffoldBackgroundColor: material.Colors.grey[50],
    appBarTheme: material.AppBarTheme(
      backgroundColor: material.Colors.white,
      elevation: 0,
      iconTheme: const material.IconThemeData(color: material.Colors.black),
      titleTextStyle: GoogleFonts.inter(
        color: material.Colors.black,
        fontSize: 20,
        fontWeight: material.FontWeight.w600,
      ),
    ),
    cardTheme: material.CardThemeData(
      elevation: 2,
      shape: material.RoundedRectangleBorder(borderRadius: material.BorderRadius.circular(12)),
      shadowColor: material.Colors.black.withValues(alpha: 0.1),
      margin: const material.EdgeInsets.symmetric(vertical: 8),
    ),
    elevatedButtonTheme: material.ElevatedButtonThemeData(
      style: material.ButtonStyle(
        backgroundColor: material.WidgetStateProperty.resolveWith<material.Color>((Set<material.WidgetState> states) {
          if (states.contains(material.WidgetState.disabled)) {
            return material.Colors.grey.shade300;
          }
          return material.Colors.blue;
        }),
        foregroundColor: material.WidgetStateProperty.all<material.Color>(material.Colors.white),
        elevation: material.WidgetStateProperty.all(0),
        shape: material.WidgetStateProperty.all<material.RoundedRectangleBorder>(
          material.RoundedRectangleBorder(borderRadius: material.BorderRadius.circular(12)),
        ),
        padding: material.WidgetStateProperty.all<material.EdgeInsetsGeometry>(
          const material.EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        textStyle: material.WidgetStateProperty.all<material.TextStyle>(
          const material.TextStyle(fontWeight: material.FontWeight.bold),
        ),
      ),
    ),
    inputDecorationTheme: material.InputDecorationTheme(
      filled: true,
      fillColor: material.Colors.grey[100],
      border: material.OutlineInputBorder(
        borderRadius: material.BorderRadius.circular(12),
        borderSide: material.BorderSide.none,
      ),
      enabledBorder: material.OutlineInputBorder(
        borderRadius: material.BorderRadius.circular(12),
        borderSide: material.BorderSide.none,
      ),
      focusedBorder: material.OutlineInputBorder(
        borderRadius: material.BorderRadius.circular(12),
        borderSide: const material.BorderSide(color: material.Colors.blue),
      ),
      errorBorder: material.OutlineInputBorder(
        borderRadius: material.BorderRadius.circular(12),
        borderSide: const material.BorderSide(color: material.Colors.red),
      ),
      contentPadding: const material.EdgeInsets.all(16),
    ),
    textTheme: GoogleFonts.interTextTheme(material.ThemeData.light().textTheme).copyWith(
      headlineSmall: GoogleFonts.inter(fontWeight: material.FontWeight.bold, fontSize: 24),
      titleLarge: GoogleFonts.inter(fontWeight: material.FontWeight.w600, fontSize: 20),
      titleMedium: GoogleFonts.inter(fontWeight: material.FontWeight.w500, fontSize: 16),
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
    ),
    dataTableTheme: material.DataTableThemeData(
      columnSpacing: 24,
      headingRowColor: material.WidgetStateProperty.all(material.Colors.grey[100]),
      dataRowMinHeight: 60,
      headingTextStyle: GoogleFonts.inter(fontWeight: material.FontWeight.w600, color: material.Colors.black),
    ),
  );
}
