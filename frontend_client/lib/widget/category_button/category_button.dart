import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key, required this.title, required this.onTap, required this.icon});

  final String title;
  final void Function() onTap;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Center(child: icon),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(ObjectFlagProperty<void Function()>.has('onTap', onTap));
  }
}
