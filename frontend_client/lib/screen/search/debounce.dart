import 'dart:async';

class Debounce {
  Debounce({required this.milliseconds});

  final int milliseconds;

  Timer? timer;

  void run(void Function() action) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    timer?.cancel();
  }
}
