import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.size, required this.builder});
  final int size;
  final IndexedWidgetBuilder builder;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sử dụng SliverToBoxAdapter với SingleChildScrollView để có thể cuộn ngang
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 120, // Chiều cao cố định cho danh mục
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: size,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder:
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 100, // Chiều rộng cố định cho mỗi danh mục
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.05),
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: builder(context, index),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('size', size));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has('builder', builder));
  }
}
