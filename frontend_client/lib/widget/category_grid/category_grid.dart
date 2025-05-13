import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.size, required this.builder});
  final int size;
  final IndexedWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 2.2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: Colors.deepPurple.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: builder(context, index),
          ),
        ),
        childCount: size,
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
