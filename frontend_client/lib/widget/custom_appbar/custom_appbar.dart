import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, this.title, this.actions});

  final Widget? title;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(title: title, actions: actions, floating: true);
  }
}
