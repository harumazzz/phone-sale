import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
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
      builder: (context) => buildDialog(title: title, content: content, actions: buildSimpleAction(context: context)),
    );
  }

  static Future<void> showCustomDialog({required BuildContext context, required Widget child}) async {
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

  static Widget buildDialog({required Widget title, required Widget content, required List<Widget> actions}) {
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

  static Future<void> showErrorDialog({required BuildContext context, required String message}) async {
    return await showSimpleDialog(context: context, title: 'Lỗi xảy ra', content: message);
  }

  static Future<void> showFlutterDialog({required BuildContext context, required Widget child}) async {
    return await showDialog(context: context, builder: (context) => child);
  }

  static Future<void> showSuccessSnackbar({required BuildContext context, required String message}) async {
    return ElegantNotification.success(
      width: 360,
      isDismissable: false,
      stackedOptions: StackedOptions(key: 'top', type: StackedType.same, itemOffset: const Offset(-5, -5)),
      title: Text('Thành công', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
      description: Text(message, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black)),
    ).show(context);
  }

  static Future<void> showErrorSnackbar({required BuildContext context, required String message}) async {
    return ElegantNotification.error(
      width: 360,
      isDismissable: false,
      stackedOptions: StackedOptions(key: 'top', type: StackedType.same, itemOffset: const Offset(-5, -5)),
      title: Text('Thất bại', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
      description: Text(message, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black)),
    ).show(context);
  }

  static Future<void> showInfoSnackbar({required BuildContext context, required String message}) async {
    return ElegantNotification.info(
      width: 360,
      isDismissable: false,
      stackedOptions: StackedOptions(key: 'top', type: StackedType.same, itemOffset: const Offset(-5, -5)),
      title: Text('Thông báo', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
      description: Text(message, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black)),
    ).show(context);
  }
}
