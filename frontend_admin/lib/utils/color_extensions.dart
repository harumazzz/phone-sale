import 'dart:ui';

/// Extension on Color to provide additional functionality
extension ColorExtension on Color {
  /// Creates a new color that matches this color with the provided values updated.
  /// Allows updating red, green, blue, or alpha components.
  Color withValues({int? red, int? green, int? blue, int? alpha}) {
    return Color.fromARGB(alpha ?? a.toInt(), red ?? r.toInt(), green ?? g.toInt(), blue ?? b.toInt());
  }
}
