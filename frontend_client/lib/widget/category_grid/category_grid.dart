import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.builder, required this.size});

  final Widget? Function(BuildContext context, int index) builder;

  final int size;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(builder, childCount: size),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<Widget? Function(BuildContext p1, int p2)>.has(
        'builder',
        builder,
      ),
    );
    properties.add(IntProperty('size', size));
  }
}
