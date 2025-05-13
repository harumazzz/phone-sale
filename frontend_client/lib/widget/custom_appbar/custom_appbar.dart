import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, this.title, this.actions});

  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title,
      actions: actions,
      floating: true,
      backgroundColor: Colors.deepPurple,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))),
      elevation: 6,
      toolbarHeight: 64,
      centerTitle: true,
    );
  }
}
