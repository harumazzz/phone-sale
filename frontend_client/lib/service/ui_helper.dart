import 'package:flutter/material.dart';

class UIHelper {
  const UIHelper._();

  static Future<void> showDetailDialog({
    required BuildContext context,
    required Widget title,
    required Widget content,
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => buildDialog(
            title: title,
            content: content,
            actions: buildSimpleAction(context: context),
          ),
    );
  }

  static Future<void> showCustomDialog({
    required BuildContext context,
    required Widget child,
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.6,
              child: child,
            ),
          ),
    );
  }

  static List<Widget> buildSimpleAction({required BuildContext context}) {
    return [
      TextButton(
        child: const Text('OK'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  static Widget buildDialog({
    required Widget title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return AlertDialog(title: title, content: content, actions: actions);
  }

  static Future<void> showSimpleDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    return await showDetailDialog(
      context: context,
      title: Text(title),
      content: Text(content, overflow: TextOverflow.ellipsis, maxLines: 4),
    );
  }

  static Future<void> showErrorDialog({
    required BuildContext context,
    required String message,
  }) async {
    return await showSimpleDialog(
      context: context,
      title: 'Lỗi xảy ra',
      content: message,
    );
  }

  static Future<void> showFlutterDialog({
    required BuildContext context,
    required Widget child,
  }) async {
    return await showDialog(context: context, builder: (context) => child);
  }
}
