import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.title, this.onRetry});
  final String title;

  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(title),
          onRetry != null
              ? const SizedBox.shrink()
              : TextButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<void Function()?>.has('onRetry', onRetry),
    );
    properties.add(StringProperty('title', title));
  }
}
