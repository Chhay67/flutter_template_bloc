import 'dart:async';
import 'package:flutter/foundation.dart';


/// Triggers GoRouter refresh when any stream emits.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    _subscriptions = streams
        .map(
          (stream) => stream.listen(
            (_) => notifyListeners(),
        onError: (_) => notifyListeners(),
      ),
    )
        .toList();

    Future.microtask(notifyListeners);
  }

  late final List<StreamSubscription<dynamic>> _subscriptions;

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }

    super.dispose();
  }
}