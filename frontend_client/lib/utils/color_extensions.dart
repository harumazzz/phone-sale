import 'dart:ui';

/// Extension on Color to provide additional functionality
extension ColorExtension on Color {
  /// Creates a new color that matches this color with the alpha channel updated to the [alpha] value.
  /// Alpha must be between 0 and 255 inclusive.
  Color withValues({int? red, int? green, int? blue, int? alpha}) {
    return Color.fromARGB(alpha ?? a.toInt(), red ?? r.toInt(), green ?? g.toInt(), blue ?? b.toInt());
  }
}
