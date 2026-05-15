part of 'app_session_cubit.dart';

@immutable
sealed class SessionState {
  const SessionState();

  bool get isLoading => this is SessionLoading;
  bool get isAuthenticated => this is SessionAuthenticated;
  bool get isUnauthenticated => this is SessionUnauthenticated;
}

final class SessionInitial extends SessionState {
  const SessionInitial();
}

final class SessionLoading extends SessionState {
  const SessionLoading();
}

final class SessionAuthenticated extends SessionState {
  const SessionAuthenticated({
    required this.session,
  });

  final SessionEntity session;
}

final class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated({this.reason});

  final String? reason;
}